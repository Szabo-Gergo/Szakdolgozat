extends Control

@export var pause_ui_layer: CanvasLayer
var is_paused = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("menu_exit"):
		is_paused = !is_paused  
		if is_paused:
			pause_ui_layer.show()
			get_tree().paused = true
			
		else:
			pause_ui_layer.hide()
			get_tree().paused = false
	pass
	
func _on_to_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu_screen.tscn")


func _on_to_hub_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Misc/hub_area.tscn")
