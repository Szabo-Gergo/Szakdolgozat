extends Line2D

var queue : Array
@export var length : int
@onready var animation_player: AnimationPlayer = $"../AnimationPlayer"
@onready var character_body_2d: CharacterBody2D = $"../.."


func _process(delta: float) -> void:
	position = -%Sword.global_position+Vector2(0,-2)
	
	queue.push_front(%Sword.global_position)
	
	if queue.size() > length:
		queue.pop_back()
	
	clear_points()
	
	for trail_part in queue:
		add_point(trail_part)
