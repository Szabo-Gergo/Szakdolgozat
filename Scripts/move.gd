extends State
class_name PlayerMovement

@onready var character_body = $"../.."
@onready var animation_tree = %AnimationTree
@onready var state_machine: Node = $".."
@export var speed = 350

var velocity
var mouse_position
var attack_cooldown : float

func enter(inputs : Dictionary = {}):
	velocity = Vector2.ZERO
	attack_cooldown = inputs.get("attack_cooldown", 0)

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	mouse_position = (character_body.global_position - character_body.get_global_mouse_position()).normalized()*-1
	
	if Input.is_action_just_pressed("dash") and Global.available_dash >= 1 and velocity != Vector2.ZERO:
		transition.emit(self, "dash", {"direction" : velocity, "speed" : speed})
	
	if Input.is_action_pressed("attack") and attack_cooldown <= 0:
		transition.emit(self, "attack", {"mouse_position": mouse_position})
		
	if Input.is_action_pressed("shoot"):
		transition.emit(self, "shoot", {"mouse_position": mouse_position})
	
func animation_update():	
		animation_tree.set("parameters/idle/blend_position", mouse_position)
		animation_tree.set("parameters/run/blend_position", velocity)

func physics_process(_delta: float):
	get_input()
	animation_update()
	attack_cooldown -= _delta
	character_body.velocity = velocity
	character_body.move_and_slide()
