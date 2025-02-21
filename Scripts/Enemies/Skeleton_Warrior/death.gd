extends State
class_name Basic_Enemy_Death

@export var root: CharacterBody2D 
@export var sprite: Sprite2D
@export var health_bar : ProgressBar 
@onready var spawner = get_node("/root/Main/Enemy_Spawner")
@onready var elite_crown: Sprite2D = $"../../EliteCrown"

var deletion_time = 2	
const EXPERIENCE = preload("res://Scenes/experience.tscn")

var i = 0
func enter(_inputs : Dictionary = {}):
	if elite_crown.visible:
		elite_crown.visible = false
		
	spawn_xp()

func physics_process(_delta: float):
	health_bar.visible = false
	
	if deletion_time > 0:
		deletion_time -= _delta
	else:
		sprite.modulate.a -= _delta
		if sprite.modulate.a <= 0:
			root.queue_free()

func spawn_xp():
	var xp = EXPERIENCE.instantiate()
	var elite_multiplier = 1
	
	if root.is_elite:
		elite_multiplier = 2
	
	xp.xp_amount = root.droped_xp_amount * elite_multiplier
	xp.position = root.position
	root.get_parent().add_child(xp)
	
	
