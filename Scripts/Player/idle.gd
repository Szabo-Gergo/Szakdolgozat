extends State
class_name Idle


@onready var character_body: CharacterBody2D = $"../.."
@onready var animation_tree: AnimationTree = %AnimationTree

var mouse_position
var attack_cooldown

func enter(inputs : Dictionary = {}):
	attack_cooldown = inputs.get("attack_cooldown", 0)
	
func exit():
	pass
	
func process(_delta: float):
	mouse_position = (character_body.global_position - character_body.get_global_mouse_position()).normalized()*-1

	
func physics_process(_delta: float):
	animation_tree.set("parameters/idle/blend_position", mouse_position)
	attack_cooldown -= _delta
	
	if Input.get_vector("left", "right", "up", "down") != Vector2.ZERO:
		transition.emit(self, "move")
	
	if Input.is_action_pressed("attack") and attack_cooldown <= 0:
		transition.emit(self, "attack", {"mouse_position": mouse_position})
		
	if Input.is_action_pressed("shoot"):
		transition.emit(self, "shoot", {"mouse_position": mouse_position})
	
