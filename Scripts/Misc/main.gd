extends Node2D
class_name Main

func _ready() -> void:
	RuntimeSaves.game_time = 0
	RuntimeSaves.enemies_defeated = 0
	RuntimeSaves.run_started = true
