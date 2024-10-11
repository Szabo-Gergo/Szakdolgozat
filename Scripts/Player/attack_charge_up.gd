extends State
class_name AttackChargeUp

var charge_time : float
var mouse_position : Vector2
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var character_body: CharacterBody2D = $"../.."

func enter(inputs : Dictionary = {}):
	charge_time = inputs.get("charge_time")
	mouse_position = (character_body.global_position - character_body.get_global_mouse_position()).normalized()*-1

func physics_process(_delta: float):
	if Input.is_action_pressed("attack"):
			charge_time += _delta
	
	if Input.is_action_just_released("attack"):
		if charge_time >= 2.7:
			transition.emit(self, "ChargeAttack")
		else:
			transition.emit(self, "Attack")

	animation_tree.set("parameters/ChargeUp/blend_position", mouse_position)
