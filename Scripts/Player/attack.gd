extends State
class_name Attack

@export var slow_percent : float
@export var charged_attack : bool

@onready var animation_tree = %AnimationTree
@onready var player: CharacterBody2D = $"../.."
@onready var player_camera: Camera2D = %PlayerCamera
@onready var trail: Sprite2D = %Trail

@onready var cooldown_timer: Timer = $CooldownTimer
@onready var combo_timer: Timer = $"../AttackCombo/ComboTimer"

var mouse_position : Vector2
var trail_direction
var camera_original_position
var charge_transition_limit : float
var stats : BaseStats

var i = 0

func enter(_inputs : Dictionary = {}):
	update_trail_position()
	player.speed *= 1.0 - (slow_percent / 100)
	
	charge_transition_limit = 0
	camera_original_position = player_camera.position
	
	cooldown_timer.start()
	player.can_attack = false
	
	combo_timer.start()
	player.can_combo = true
	
func physics_process(delta: float) -> void:	
	animation_update()

#	If the attack is held transition to the charge up
	if Input.is_action_pressed("attack"):
		charge_transition_limit += delta
		if charge_transition_limit >= 0.2:
			transition.emit(self, "AttackChargeUp", {"charge_time": charge_transition_limit})
		
	if Input.is_action_just_pressed("dash") and player.available_dash >= 1 and player.velocity != Vector2.ZERO:
		transition.emit(self, "Dash", {"direction" : mouse_position*player.get("base_stats").speed})
		

func _on_attack_finished(anim_name: StringName) -> void:
	if "Attack" in anim_name:
		transition.emit(self, "idle") 
	
func animation_update():
	animation_tree.set("parameters/Attack/blend_position", mouse_position)
	
func _on_enemy_hit(_area: Area2D) -> void:
	if _area.is_in_group("Enemy_HurtBox"):
		player._add_ammo() 

func update_trail_position():
		mouse_position = (player.global_position - player.get_global_mouse_position()).normalized()*-1
		trail_direction = trail.get_global_mouse_position()
		trail.look_at(trail_direction)
		animation_tree.set("parameters/Attack/blend_position", mouse_position)


func camera_snap():
	player_camera.position += mouse_position*15
	await get_tree().create_timer(0.075).timeout
	player_camera.position = camera_original_position
	
func exit():
	player.speed = player.base_stats.speed
	player.can_combo = true
