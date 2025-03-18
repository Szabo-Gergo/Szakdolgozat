extends Control

const KEYBINDING_UI = preload("res://Scenes/UI/keybinding.tscn")
const KEYBINDINGS = ["up", "left", "down", "right", "dash", "attack", "shoot", "interact"]
@onready var volume_slider: HSlider = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/VolumeSlider
@onready var resolution_option_box: OptionButton = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/ResolutionOptionBox
@onready var fullscreen_toggle: CheckButton = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/FullscreenToggle
@onready var borderless_toggle: CheckButton = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/BorderlessToggle
@onready var v_box_container: VBoxContainer = $PanelContainer/MarginContainer/ScrollContainer/VBoxContainer/ScrollContainer/VBoxContainer

const RESOLUTIONS = [
	Vector2i(640, 360),   
	Vector2i(1280, 720),  
	Vector2i(1920, 1080),
	Vector2i(2560, 1440), 
	Vector2i(3840, 2160),
	Vector2i(2560, 1080), 
	Vector2i(3440, 1440) 
]


var saved_config : Dictionary

var is_remapping : bool = false
var remap_button : Button
var remap_action : String
var controls_reset : bool = false

func _ready() -> void:
	saved_config = ConfigHandler.load_settings()

	audio_setup()
	display_setup()
	controls_setup()
	
	
func audio_setup():
	volume_slider.value = saved_config.get("volume")
	
	
func display_setup():
	for res in RESOLUTIONS:
		resolution_option_box.add_item(str(res))
	
	var chosen_resolution = RESOLUTIONS.find(saved_config.get("resolution"))
	resolution_option_box.select(chosen_resolution)
	_on_resolution_option_selected(chosen_resolution)
	fullscreen_toggle.button_pressed = saved_config.get("fullscreen")
	borderless_toggle.button_pressed = saved_config.get("borderless")
	
	
func controls_setup():
	var controls = ConfigHandler.load_controls()
	
	for action_event in controls.keys():
		InputMap.action_erase_events(action_event)
		InputMap.action_add_event(action_event, controls[action_event])
		
		var keybinding = KEYBINDING_UI.instantiate()
		keybinding.text = action_event
		
		var key_used = controls[action_event].as_text()
		keybinding.get_child(0).set("text", key_used)
		
		keybinding.connect("pressed", remap_keys.bind(keybinding, action_event))
		v_box_container.add_child(keybinding)


func remap_keys(button, action):
	if remap_action == "" and remap_button == null:
		remap_button = button
		remap_action = action	
		button.get_child(0).set("text", "Press a key...")


func _input(event: InputEvent) -> void:
	if remap_action == "" or remap_button == null:
		return  

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			return  

		save_and_update(event, "keyboard_" + str(event.keycode))
	elif event is InputEventMouseButton and event.pressed:
		event.double_click = false
		save_and_update(event, "mouse_" + str(event.button_index))

	accept_event()


func save_and_update(event: InputEvent, action_string: String) -> void:
	InputMap.action_erase_events(remap_action)
	InputMap.action_add_event(remap_action, event)
	ConfigHandler.save_setting("controls", remap_action, action_string)

	remap_button.get_child(0).set("text", event.as_text().replace(" (Physical)", "").replace(" (Double Click)", ""))

	remap_action = ""
	remap_button = null


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		save_and_exit()


func _on_reset_button_pressed() -> void:
	for child in v_box_container.get_children():
		child.queue_free()
		
	InputMap.load_from_project_settings()
	for key in KEYBINDINGS:
		var action = InputMap.action_get_events(key)
			
		var code
		if action[0] is InputEventKey:
			ConfigHandler.save_setting("controls", key, "keyboard_" + str(action[0].physical_keycode))
		elif action[0] is InputEventMouseButton:
			ConfigHandler.save_setting("controls", key, "mouse_" + str(action[0].button_index))
	
	controls_setup()


func _on_fullscreen_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)	
		resolution_option_box.disabled = true
		if borderless_toggle.is_pressed():
			borderless_toggle.set_pressed(false)
		borderless_toggle.disabled = true
		
		var screen_res_index = RESOLUTIONS.find(DisplayServer.screen_get_size())
		resolution_option_box.select(screen_res_index)
		
		
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		resolution_option_box.disabled = false
		borderless_toggle.disabled = false
		saved_config = ConfigHandler.load_settings()
		resolution_option_box.select(RESOLUTIONS.find(saved_config.resolution))
		

		
	ConfigHandler.save_setting("display", "fullscreen", toggled_on)


func _on_borderless_button_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,true)
	else:
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS,false)
		
	ConfigHandler.save_setting("display", "borderless", toggled_on)


func _on_resolution_option_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTIONS[index])
	ConfigHandler.save_setting("display", "resolution", RESOLUTIONS[index])


func _on_exit_pressed() -> void:
	save_and_exit()


func save_and_exit():
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu_screen.tscn")


func _on_volume_change(value_changed: bool) -> void:
	if value_changed:
		AudioServer.set_bus_volume_db(0, volume_slider.value/5)
		ConfigHandler.save_setting("audio", "volume", volume_slider.value)
