extends State

@onready var skeleton: CharacterBody2D = $"../.."
@onready var skeleton_sprite: Sprite2D = $"../../Skeleton_Sprite"

var deletion_time = 10	

func physics_process(_delta: float):
	if deletion_time > 0:
		deletion_time -= _delta
	else:
		skeleton_sprite.modulate.a -= _delta
		print(skeleton_sprite.modulate.a)
		if skeleton_sprite.modulate.a <= 0:
			skeleton.queue_free()
