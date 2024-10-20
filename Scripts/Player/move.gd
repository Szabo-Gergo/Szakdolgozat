extends State
class_name PlayerMovement

@onready var character_body = $"../.."
@onready var animation_tree = %AnimationTree
@onready var state_machine: Node = $".."
@export var speed = Global.player_speed

var velocity : Vector2
var mouse_position : Vector2
var input_direction : Vector2
var attack_cooldown : float

func enter(inputs : Dictionary = {}):
	attack_cooldown = inputs.get("attack_cooldown", 0)
	

func move_player():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed	
	character_body.velocity = velocity
	character_body.move_and_slide()

func handle_transitions():
	mouse_position = (character_body.global_position - character_body.get_global_mouse_position()).normalized()*-1

	if Input.is_action_just_pressed("dash") and Global.available_dash >= 1 and velocity != Vector2.ZERO:
		transition.emit(self, "dash", {"direction" : velocity, "speed" : speed})
	
	if Input.is_action_pressed("attack") and attack_cooldown <= 0:
		transition.emit(self, "attack", {"mouse_position": mouse_position})
		
	if Input.is_action_pressed("shoot"):
		transition.emit(self, "shoot", {"mouse_position": mouse_position})
	
	if character_body.velocity == Vector2.ZERO:
		transition.emit(self, "idle")
	
func animation_update():	
		animation_tree.set("parameters/run/blend_position", velocity)

func physics_process(_delta: float):
	handle_transitions()
	animation_update()
	move_player()
	attack_cooldown -= _delta
	
	
