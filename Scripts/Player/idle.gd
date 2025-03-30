extends State
class_name Idle


@onready var player: CharacterBody2D = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree

var mouse_position
var attack_cooldown

func enter(inputs : Dictionary = {}):
	attack_cooldown = inputs.get("attack_cooldown", 0)
	
func exit():
	pass
	
func physics_process(_delta: float):
	attack_cooldown -= _delta
	mouse_position = (player.global_position - player.get_global_mouse_position()).normalized() * -1
	animation_tree.set("parameters/"+player._get_animation_tree_name()+"/StateMachine/Idle/BlendSpace2D/blend_position", mouse_position)
		

	if Input.is_action_pressed("shoot"):
		transition.emit(self, "shoot", {"mouse_position": mouse_position})
