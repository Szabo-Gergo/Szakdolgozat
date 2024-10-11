extends State
class_name Attack

@export var damage : int = 1
@export var slide_speed : float = 0
@export var charged_attack : bool

@onready var animation_tree = %AnimationTree
@onready var character_body: CharacterBody2D = $"../.."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var player_camera: Camera2D = %PlayerCamera
@onready var trail: Sprite2D = %Trail


var mouse_position : Vector2
var charge_time : float
var attack_cooldown : float = 0.3
var trail_direction
var camera_original_position

func enter(inputs : Dictionary = {}):
	charge_time = 0
	charged_attack = false
	mouse_position = inputs.get("mouse_position")
	trail_direction = trail.get_global_mouse_position()
	camera_original_position = player_camera.position
	
func physics_process(delta: float) -> void:
		animation_update()
		character_body.velocity = mouse_position*slide_speed
		character_body.move_and_slide()			
		trail.look_at(trail_direction)
		
		
		
		if Input.is_action_pressed("attack"):
			
			charge_time += delta
			if charge_time >= 0.2:
				animation_tree.set("parameters/conditions/attacking", false)
				animation_tree.set("parameters/conditions/combo", false)	
				animation_tree.set("parameters/conditions/charge_up", true)
						
			if charge_time >= 2.7:
				charged_attack = true
				charge_time = 0
		
		if Input.is_action_just_released("attack"):
			camera_snap()
			animation_tree.set("parameters/conditions/charge_up", false)
			trail_direction = trail.get_global_mouse_position()
			update_mouse_position()
			
			if charged_attack:
				animation_tree.set("parameters/conditions/charged_attack", true)
			elif animation_tree.get("parameters/conditions/attacking"):
				animation_tree.set("parameters/conditions/attacking", false)
				animation_tree.set("parameters/conditions/combo", true)		
			else:
				animation_tree.set("parameters/conditions/attacking", true)
				
		
		if Input.is_action_just_pressed("dash") and Global.available_dash >= 1 and character_body.velocity != Vector2.ZERO:
			transition.emit(self, "dash", {"direction" : mouse_position*350})
			
		
			
			
func _on_attack_finished(anim_name: StringName) -> void:
	animation_tree.set("parameters/conditions/stop_attack", true)
	
	if  "ChargeAttack" in anim_name:
		
		animation_tree.set("parameters/conditions/charged_attack", false)
		transition.emit(self, "move") 
		
	if "Attack" in anim_name and !animation_tree.get("parameters/conditions/combo"):
		
		animation_tree.set("parameters/conditions/stop_attack", true)
		animation_tree.set("parameters/conditions/attacking", false)
		transition.emit(self, "move") 
		
	if "Combo" in anim_name and !animation_tree.get("parameters/conditions/charge_up"):
		
		animation_tree.set("parameters/conditions/stop_attack", true)
		animation_tree.set("parameters/conditions/combo", false)
		transition.emit(self, "move", {"attack_cooldown": attack_cooldown}) 


func animation_update():
	animation_tree.set("parameters/conditions/stop_attack", false)
	animation_tree.set("parameters/Attack/blend_position", mouse_position)
	animation_tree.set("parameters/Combo/blend_position", mouse_position)
	animation_tree.set("parameters/ChargeAttack/blend_position", mouse_position)
	animation_tree.set("parameters/ChargeUp/blend_position", mouse_position)


func _on_enemy_hit(body: Node2D) -> void:
	if Global.ammo < Global.max_ammo:
		Global.ammo += 1 

func update_mouse_position():
		mouse_position = (character_body.global_position - character_body.get_global_mouse_position()).normalized()*-1

func camera_snap():
	
	player_camera.position += mouse_position*15
	await get_tree().create_timer(0.075).timeout
	player_camera.position = camera_original_position
