extends Node

var settings : Dictionary = {}
const KEYBINDINGS = ["up", "left", "down", "right", "dash", "attack", "shoot"]

func _ready() -> void:
	if settings.is_empty():
		settings = ConfigHandler.load_settings()
	
	if !settings.is_empty():
		AudioServer.set_bus_volume_db(0, settings.volume/5)
		DisplayServer.window_set_size(settings.resolution)
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, settings.borderless)

		if settings.fullscreen:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
		else:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

		var controls = ConfigHandler.load_controls()
		for action in controls:
			InputMap.action_erase_events(action)
			InputMap.action_add_event(action, controls[action])


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
