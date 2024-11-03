extends State
class_name Attack

@export var damage : int = 1
@export var slide_speed : float = 0
@export var charged_attack : bool

@onready var animation_tree = %AnimationTree
@onready var player: CharacterBody2D = $"../.."
@onready var player_camera: Camera2D = %PlayerCamera
@onready var trail: Sprite2D = %Trail

var mouse_position : Vector2
var trail_direction
var camera_original_position
var charge_transition_limit : float

func enter(_inputs : Dictionary = {}):
	update_trail_position()
	charge_transition_limit = 0
	camera_original_position = player_camera.position

	
func physics_process(delta: float) -> void:
	
	animation_update()
#	Slide the player forward slightly
	slide_player()

#		If the attack is held transition to the charge up
	if Input.is_action_pressed("attack"):
		charge_transition_limit += delta
		if charge_transition_limit >= 0.2:
			transition.emit(self, "AttackChargeUp", {"charge_time": charge_transition_limit})

	if Input.is_action_just_pressed("attack"):
		transition.emit(self, "AttackCombo")
		
	if Input.is_action_just_pressed("dash") and Global.available_dash >= 1 and player.velocity != Vector2.ZERO:
		transition.emit(self, "Dash", {"direction" : mouse_position*Global.player_speed})
		

func _on_attack_finished(anim_name: StringName) -> void:
	if "Attack" in anim_name:
		transition.emit(self, "idle", {"attack_cooldown": 0.075}) 
	
func animation_update():
	animation_tree.set("parameters/Attack/blend_position", mouse_position)
	
func _on_enemy_hit(_body: Node2D) -> void:
	if Global.ammo < Global.max_ammo:
		Global.ammo += 1 

func update_trail_position():
		mouse_position = (player.global_position - player.get_global_mouse_position()).normalized()*-1
		trail_direction = trail.get_global_mouse_position()
		trail.look_at(trail_direction)

func camera_snap():
	player_camera.position += mouse_position*15
	await get_tree().create_timer(0.075).timeout
	player_camera.position = camera_original_position
	
func slide_player():
#		Slide the player forward slightly
		player.velocity = mouse_position*slide_speed
		player.move_and_slide()
