extends Node2D

var Enemies = {
	"Base_Skeleton": preload("res://Scenes/Enemies/Skeleton.tscn"),
	"Skeleton_Mage": preload("res://Scenes/Enemies/SkeletonMage.tscn"),
	"Slime": preload("res://Scenes/Enemies/Slime.tscn"),
	"Brain_Dog":  preload("res://Scenes/Enemies/BrainDog.tscn")
}

@export var TURNED_ON = true

var viewport_size = self.get_viewport()
@onready var camera_position = get_node("/root/Main/Player/PlayerCamera").global_position

var current_enemies = 0
var max_enemies = 50

func get_spawn_position():
	var viewport_size = get_viewport().size
	var camera_position = get_viewport().get_camera_2d().global_position

	# Define spawn buffer (distance outside the viewport)
	var buffer = 50

	# Randomly choose an edge
	match randi() % 4:
		0: # Top
			return Vector2(
			randf_range(camera_position.x - viewport_size.x / 2, camera_position.x + viewport_size.x / 2),
			camera_position.y - viewport_size.y / 2 - buffer
			)
		1: # Bottom
			return Vector2(
				randf_range(camera_position.x - viewport_size.x / 2, camera_position.x + viewport_size.x / 2),
				camera_position.y + viewport_size.y / 2 + buffer
			)
		2: # Left
			return Vector2(
				camera_position.x - viewport_size.x / 2 - buffer,
				randf_range(camera_position.y - viewport_size.y / 2, camera_position.y + viewport_size.y / 2)
			)
		3: # Right
			return Vector2(
				camera_position.x + viewport_size.x / 2 + buffer,
				randf_range(camera_position.y - viewport_size.y / 2, camera_position.y + viewport_size.y / 2)
			)


func _on_timer_timeout() -> void:
	if current_enemies <= max_enemies and TURNED_ON:
		spawn_enemy("Base_Skeleton")
	
	
func spawn_enemy(enemy_key):
	if not Enemies.has(enemy_key):
		print("Error: Enemy key not found:", enemy_key)
		return

	var enemy_scene = Enemies[enemy_key]
	var enemy_instance = enemy_scene.instantiate()
	add_child(enemy_instance)
	
	# Set the spawn position outside the viewport
	enemy_instance.global_position = get_spawn_position()

	current_enemies += 1
	print(current_enemies)
