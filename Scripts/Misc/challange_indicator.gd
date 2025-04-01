extends Control

@export var challange_title : String
@export var max_challange_amount : int
@export var challange_effect : ChallangeEffectResource
@export var point_color : Color
@export var border_color : Color
#percentile
@export var challange_increase_per_level : float
@onready var h_box_container: HBoxContainer = $MarginContainer/HBoxContainer/HBoxContainer
@onready var challange_value_label: Label = $MarginContainer/HBoxContainer/ChallangeValueLabel
const CHALLANGE_POINT = preload("res://Scenes/UI/challange_point.tscn")

var challange_value : float = 0
var challange_level : int = 0

func _ready() -> void:	
	
	%ChallangeTitle.text = challange_title
	challange_value_label.text = "+"+str(challange_effect.current_value*challange_level*100)+"%"
	for i in range(0, max_challange_amount):
		
		var increase_box = CHALLANGE_POINT.instantiate()
		increase_box.custom_minimum_size = Vector2(h_box_container.custom_minimum_size.x/max_challange_amount, 30)
		
		var increase_box_style = increase_box.get_theme_stylebox("panel")
		increase_box_style.set("bg_color", border_color)
		increase_box_style.set("border_color", point_color)
		
		var increase_point : Panel = increase_box.get_child(0)
		
		var point_style = increase_point.get_theme_stylebox("panel")
		point_style.set("bg_color", point_color)
		point_style.set("border_color", border_color)
		h_box_container.add_child(increase_box)

func update_health_bar():
	var total_stats : int
	
	if total_stats == 0:
		visible = false


func _on_increase_pressed() -> void:
	if challange_level < max_challange_amount:
		var point = h_box_container.get_child(_get_active_points())
		challange_effect.current_value += challange_increase_per_level
		challange_value_label.text = "+"+str(challange_effect.current_value*100)+"%"
		point.get_child(0).visible = true
		challange_level += 1
		
		
func _on_decrease_pressed() -> void:
	if challange_level > 0:
		var point = h_box_container.get_child(_get_active_points()-1)
		challange_level -= 1
		challange_effect.current_value -= challange_increase_per_level
		challange_value_label.text = "+"+str(challange_effect.current_value*100)+"%"
		point.get_child(0).visible = false
	

func _get_active_points():
	var sum = 0
	for challange_point in h_box_container.get_children():
		if challange_point.get_child(0).visible:
			sum += 1
	return sum

func _get_challange_effect() -> ChallangeEffectResource:
	return challange_effect
