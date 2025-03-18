extends Control
@onready var pause_ui_layer: CanvasLayer = $".."
var is_paused = false

func _input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and event.keycode == KEY_ESCAPE:
		is_paused = !is_paused  
		
		if is_paused:
			Engine.time_scale = 0 
			pause_ui_layer.visible = true
		else:
			Engine.time_scale = 1 
			pause_ui_layer.visible = false

func _on_to_main_menu_pressed() -> void:
	Engine.time_scale = 1 
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu_screen.tscn")


func _on_to_hub_pressed() -> void:
	Engine.time_scale = 1 
	get_tree().change_scene_to_file("res://Scenes/Misc/hub_area.tscn")
