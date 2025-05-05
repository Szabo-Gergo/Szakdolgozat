extends State
class_name Attack

@export var slow_percent : float
@export var charged_attack : bool
@onready var melee_weapon: MeleeWeapon = %MeleeWeapon
@onready var outfit: Outfit = %Outfit

@onready var animation_tree = %AnimationTree
@onready var player: CharacterBody2D = $"../.."
@onready var player_camera: Camera2D = %PlayerCamera

@export var cooldown_timer: Timer 
@export var combo_timer: Timer

var mouse_position : Vector2
var trail_direction
var camera_original_position

func enter(_inputs : Dictionary = {}):
	update_trail_position()
	
	player.speed *= 1.0 - (slow_percent / 100)
	camera_original_position = player_camera.position
	
	cooldown_timer.start()
	player.can_attack = false
	combo_timer.start()
	
	
func physics_process(delta: float) -> void:	
	animation_update()

	if Input.is_action_just_pressed("dash") and player.available_dash >= 1 and player.velocity != Vector2.ZERO:
		transition.emit(self, "Dash")
		

func _on_attack_finished(anim_name: StringName) -> void:
	if "Attack" in anim_name:
		transition.emit(self, "idle") 
	
	
func animation_update():
	animation_tree.set("parameters/"+player._get_animation_tree_name()+"/StateMachine/Attack/BlendSpace2D/blend_position", mouse_position)
	
	
func _on_enemy_hit(area: Area2D) -> void:
	if area.is_in_group("Enemy_HurtBox"):	
		var status_effects : StatusEffects = melee_weapon.melee_resource.status_effect
		if status_effects:
			status_effects.apply_effect(area.get_parent(), melee_weapon.melee_resource.damage)
		player._add_ammo() 


func update_trail_position():
	# Get normalized direction to the mouse
	mouse_position = (player.global_position - player.get_global_mouse_position()).normalized()*-1
	
	# Apply offset in that direction
	var offset = Vector2(%MeleeWeapon.weapon_setup_data[%MeleeWeapon.current_weapon_index]["offset"])
	melee_weapon.trail.position = mouse_position * offset.length()
	melee_weapon.trail.look_at(player.get_global_mouse_position())
	animation_tree.set("parameters/Attack/BlendSpace2D/blend_position", mouse_position)

	
func exit():
	player.speed = outfit.outfit_resource.speed
	player.can_combo = true


	
