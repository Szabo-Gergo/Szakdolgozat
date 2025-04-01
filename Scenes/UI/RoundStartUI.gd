extends Control

@export var challange_effects : Array
@onready var challange_container: VBoxContainer = %ChallangeContainer

@export var upgrade_material_gain_buff : float = 1
func _on_teleport_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")

func _get_challanges():
	for challange_setter in challange_container.get_children():
		var i = 1
