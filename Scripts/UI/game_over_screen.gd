extends Control

@export var enemies_defeated_number : Label
@export var time_number : Label
@export var upgrade_material_gained : Label


func _on_back_to_hub_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu_screen.tscn")
