extends State
class_name Attack

@export var damage : int = 1
@export var slide_speed : float = 0
@onready var animation_tree = %AnimationTree
@onready var character_body_2d: CharacterBody2D = $"../.."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var mouse_position : Vector2
var charged_attack : bool
var is_charging : bool 
var charge_time : float


func enter(inputs : Dictionary = {}):
	charge_time = 0
	charged_attack = false
	is_charging = false
	mouse_position = inputs.get("mouse_position")
	animation_tree.set("parameters/Attack1/blend_position", mouse_position)
	animation_tree.set("parameters/Attack2/blend_position", mouse_position)
	animation_tree.set("parameters/ChargeAttack/blend_position", mouse_position)
	animation_tree.set("parameters/ChargeUp/blend_position", mouse_position)

func physics_process(delta: float) -> void:
		character_body_2d.velocity = mouse_position*slide_speed
		character_body_2d.move_and_slide()
		
		if Input.is_action_just_released("attack"):
			animation_tree.set("parameters/conditions/charge_up", false)
			if charged_attack:
				animation_tree.set("parameters/conditions/charged_attack", true)
				pass
			else:
				animation_tree.set("parameters/conditions/attacking", true)
				
		if Input.is_action_just_pressed("attack"):
			animation_tree.set("parameters/conditions/combo", true)	
		elif Input.is_action_pressed("attack"):
			charge_time += delta
			if charge_time >= 0.5:
				animation_tree.set("parameters/conditions/charge_up", true)
				is_charging = true
						
		if charge_time >= 4:
			charged_attack = true
		
		if Input.is_action_just_pressed("dash") and Global.available_dash >= 1 and character_body_2d.velocity != Vector2.ZERO:
			transition.emit(self, "dash", {"direction" : mouse_position*350})
		
		
			
func _on_attack_finished(anim_name: StringName) -> void:	
	if "Attack" in anim_name and !animation_tree.get("parameters/conditions/combo"):
		animation_tree.set("parameters/conditions/attacking", false)
		transition.emit(self, "move") 
		
	elif "Attack2" in anim_name:
		animation_tree.set("parameters/conditions/combo", false)
		animation_tree.set("parameters/conditions/attacking", false)
		transition.emit(self, "move") 

	elif  "ChargeAttack" in anim_name:
		animation_tree.set("parameters/conditions/charged_attack", false)
		animation_tree.set("parameters/conditions/attacking", false)
