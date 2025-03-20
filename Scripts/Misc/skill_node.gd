extends Control
class_name SkillNode

@export var texture : CompressedTexture2D
@export var upgrade_cost : int = 10
@export var current_level : int = 0
@export var max_level : int
@export var is_locked : bool
@export var is_finished : bool

@onready var panel_container: PanelContainer = $PanelContainer
@onready var button: Button = $PanelContainer/Button
@onready var level_label: Label = $PanelContainer/LevelLabel
@onready var cost_label: Label = $PanelContainer/CostLabel
@onready var line: Line2D = $Line

var parent

func _ready() -> void:
	button.icon = texture
	pivot_offset = size/2
	parent = get_parent()
	parent_setup()
	
	update_labels()
	if is_finished:
		change_to_finished()
	
	if is_locked:
		change_to_locked()
	
		
func _on_button_pressed() -> void:
	if PlayerSkillStatHandler.use_currency(upgrade_cost) and !is_locked and !is_finished:
		upgrade_cost *= 2
		current_level += 1
		check_child_connection()
		update_labels()
		print(str(current_level)+"/"+str(max_level))
		if current_level == max_level:
			change_to_finished()
	elif !is_locked and !is_finished:
		cost_label.set("theme_override_colors/font_color", Color(0.71, 0.094, 0.094))
		await get_tree().create_timer(0.25).timeout
		print("did this run?")
		cost_label.set("theme_override_colors/font_color", Color(1, 1, 1))
		
func update_labels():
	level_label.text = str(current_level)+"|"+str(max_level)
	cost_label.text = str(upgrade_cost)

func change_to_locked():
		cost_label.set("theme_override_colors/font_color", Color(1, 1, 1, 0.5))
		level_label.set("theme_override_colors/font_color", Color(1, 1, 1, 0.5))
		button.set("theme_override_colors/icon_normal_color", Color(1,1,1,0.5))
		button.disabled = true
		is_locked = true
		
func change_to_finished():
	var panel_style : StyleBoxFlat = panel_container.get_theme_stylebox("panel")
	panel_style.border_color = "#128d1d"			
	is_finished = true
	if is_finished:
		check_child_connection()
		update_line_connection()
	
func change_to_unlocked():
	is_locked = false
	button.disabled = false
	cost_label.set("theme_override_colors/font_color", Color(1, 1, 1,1))
	level_label.set("theme_override_colors/font_color", Color(1, 1, 1,1))
	button.set("theme_override_colors/icon_normal_color", Color(1,1,1,1))
	
func parent_setup():
	if parent is SkillNode:
		var parent_position = parent.global_position + panel_container.size/2
		var self_position = global_position + panel_container.size/2
		line.points = [line.to_local(parent_position), line.to_local(self_position)]
		update_line_connection()

func update_line_connection():
	if line.points.size() > 0:
		if parent.is_locked:
			line.default_color = "#9191913b"
			change_to_locked()
		elif parent.is_finished and is_finished:
			line.default_color = "#128d1d"
		elif !parent.is_locked and parent.current_level > 0:
			line.default_color = "#cccccc"
			change_to_unlocked()
	
func check_child_connection():
	for child in get_children():
		if child is SkillNode:
			child.update_line_connection()
