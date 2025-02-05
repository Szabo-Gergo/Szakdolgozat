extends State
class_name Basic_Enemy_Death

@export var root: CharacterBody2D 
@export var sprite: Sprite2D
@export var health_bar : ProgressBar 
@onready var spawner = get_node("/root/Main/Enemy_Spawner")
var deletion_time = 2	

func physics_process(_delta: float):
	health_bar.visible = false
	
	if deletion_time > 0:
		deletion_time -= _delta
	else:
		sprite.modulate.a -= _delta
		if sprite.modulate.a <= 0:
			root.queue_free()
			spawner.current_enemies -= 1

	
