extends Basic_Enemy_Move
class_name  FleeState

@export var randomness_strength: float = 0.6
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = 1.4
	timer.connect("timeout", end_flee)
	timer.one_shot = true
	add_child(timer)

func enter(_inputs : Dictionary = {}):
	super()
	timer.start()

func exit():
	super()

func update_movement(delta : float):
	var direction = (root.global_position - root.player.global_position).normalized() 
	var random_offset = Vector2( randi_range(-randomness_strength, randomness_strength), randi_range(-randomness_strength, randomness_strength) ) 
	var randomized_direction = (direction + random_offset).normalized()
	root.velocity = randomized_direction * root.base_stats.speed
	root.move_and_slide()	
	
func end_flee():
	transition.emit(self,"Move")
