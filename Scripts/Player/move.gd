extends State
class_name PlayerMovement

@onready var animation_tree = %AnimationTree
@onready var player: CharacterBody2D = $"../.."

var speed : int
var velocity : Vector2
var mouse_position : Vector2
var input_direction : Vector2
var attack_cooldown : float


func _ready() -> void:
		speed = player.base_stats.speed

func enter(inputs : Dictionary = {}):
	attack_cooldown = inputs.get("attack_cooldown", 0)


func move_player():
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed	* player.reversed
	player.velocity = velocity
	player.move_and_slide()


func handle_transitions():
	mouse_position = (player.global_position - player.get_global_mouse_position()).normalized()*-1

	if Input.is_action_just_pressed("dash") and player.available_dash >= 1 and velocity != Vector2.ZERO and $"../..".can_dash:
		transition.emit(self, "dash", {"direction" : velocity, "speed" : speed})
	
	if Input.is_action_pressed("attack") and attack_cooldown <= 0:
		transition.emit(self, "attack", {"mouse_position": mouse_position})
		
	if Input.is_action_pressed("shoot"):
		transition.emit(self, "shoot", {"mouse_position": mouse_position})
	
	if player.velocity == Vector2.ZERO and input_direction == Vector2.ZERO:
		transition.emit(self, "idle")

	
func animation_update():	
		animation_tree.set("parameters/run/blend_position", velocity)

	
func physics_process(_delta: float):
	move_player()
	handle_transitions()
	animation_update()
	attack_cooldown -= _delta
	
	
