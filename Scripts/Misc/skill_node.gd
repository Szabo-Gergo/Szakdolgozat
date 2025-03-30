extends Control
class_name SkillNode

@export var node_id : String
@export var skill_resource : SkillNodeResource
@export var skill_tree_handler: SkillTreeHandler
@onready var upgrade_menu: Control = owner
@onready var panel_container: PanelContainer = $PanelContainer
@onready var button: Button = $PanelContainer/Button
@onready var level_label: Label = $PanelContainer/LevelLabel
@onready var cost_label: Label = $PanelContainer/CostLabel
@onready var line: Line2D = $Line

var parent

func _ready() -> void:
	
	check_child_connection()
	button.icon = skill_resource.texture
	pivot_offset = size/2
	parent = get_parent()
	if !skill_resource.is_finished:
		var current_level_upgrade = skill_resource.upgrades_per_level[skill_resource.current_level]
		button.tooltip_text = current_level_upgrade._get_upgrades_string()
	parent_setup()
	
	update_labels()
	if skill_resource.is_finished:
		change_to_finished()
	
	if skill_resource.is_locked:
		change_to_locked()

func load_resource(saved_skill_resource : SkillNodeResource):
	skill_resource = saved_skill_resource
	_ready()


func _on_button_pressed() -> void:
	if PlayerSkillStatHandler.use_currency(skill_resource.upgrade_cost) and !skill_resource.is_locked and !skill_resource.is_finished:
		skill_resource.upgrade_cost *= 2
		skill_resource.upgrades_per_level[skill_resource.current_level].apply_stat(upgrade_menu.player._get_melee_weapon())
		skill_resource.current_level += 1
		check_child_connection()
		update_labels()
		skill_tree_handler.save_all_trees()
		if skill_resource.current_level == skill_resource.max_level:
			change_to_finished()
	
	if !PlayerSkillStatHandler.use_currency(skill_resource.upgrade_cost):
		cost_label.set("theme_override_colors/font_color", Color(0.71, 0.094, 0.094))
		await get_tree().create_timer(0.25).timeout
		cost_label.set("theme_override_colors/font_color", Color(1, 1, 1))

func update_labels():
	level_label.text = str(skill_resource.current_level)+"|"+str(skill_resource.max_level)
	cost_label.text = str(skill_resource.upgrade_cost)

func change_to_locked():
		cost_label.set("theme_override_colors/font_color", Color(1, 1, 1, 0.5))
		level_label.set("theme_override_colors/font_color", Color(1, 1, 1, 0.5))
		button.set("theme_override_colors/icon_normal_color", Color(1,1,1,0.5))
		button.disabled = true
		skill_resource.is_locked = true
		
func change_to_finished():
	var panel_style : StyleBoxFlat = panel_container.get_theme_stylebox("panel")
	panel_style.border_color = "#128d1d"			
	cost_label.visible = false
	skill_resource.is_finished = true
	
	check_child_connection()
	update_line_connection()
	
func change_to_unlocked():
	skill_resource.is_locked = false
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
		if parent.skill_resource.is_locked:
			line.default_color = "#9191913b"
			change_to_locked()
		elif parent.skill_resource.is_finished and skill_resource.is_finished:
			line.default_color = "#128d1d"
		elif !parent.skill_resource.is_locked and parent.skill_resource.current_level > 0:
			line.default_color = "#cccccc"
			change_to_unlocked()
	
func check_child_connection():
	for child in get_children():
		if child is SkillNode:
			child.update_line_connection()
