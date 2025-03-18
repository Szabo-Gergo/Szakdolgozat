extends Node

var settings_config = ConfigFile.new()
const SAVE_FILE_PATH = "user://settings.ini"

func _ready() -> void:
	if !FileAccess.file_exists(SAVE_FILE_PATH):
		settings_config.set_value("audio", "volume", 100)
		settings_config.set_value("display", "resolution", Vector2i(640,360))
		settings_config.set_value("display", "fullscreen", false)
		settings_config.set_value("display", "borderless", false)
		settings_config.set_value("controls", "up", "keyboard_87")
		settings_config.set_value("controls", "left", "keyboard_65")
		settings_config.set_value("controls", "down", "keyboard_83")
		settings_config.set_value("controls", "right", "keyboard_68")
		settings_config.set_value("controls", "dash", "keyboard_4194325")
		settings_config.set_value("controls", "attack", "mouse_1")
		settings_config.set_value("controls", "shoot", "mouse_2")
		settings_config.set_value("controls", "interact", "keyboard_69")
	else:
		settings_config.load(SAVE_FILE_PATH)
		
		
func load_settings():
	var settings : Dictionary = {}
	for section in settings_config.get_sections():
		for key in settings_config.get_section_keys(section):
			settings[key] = settings_config.get_value(section,key)
	return settings

	
func save_setting(section : String, key : String, value):
	print("Saved setting: "+str(section)+" "+str(key)+" "+str(value))
	settings_config.set_value(section, key, value)
	settings_config.save(SAVE_FILE_PATH)
	
func load_controls():
	var control_settings : Dictionary = {}
	for key in settings_config.get_section_keys("controls"):
		var input_event 
		var input_data = settings_config.get_value("controls", key).split("_")
		var type = input_data[0]
		var code = int(input_data[1])
		
		if type == "keyboard":
			input_event = InputEventKey.new()
			input_event.keycode = code
		elif type == "mouse":
			input_event = InputEventMouseButton.new()
			input_event.button_index = code
		
		control_settings[key] = input_event
	return control_settings
		
