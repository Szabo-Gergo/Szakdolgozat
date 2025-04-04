extends HBoxContainer
class_name PointContainer
const CHALLANGE_POINT = preload("res://Scenes/UI/challange_point.tscn")

@export var max_point : int
@export var border_color : Color
@export var border_width : int
@export var inner_border_width : int
@export var point_color : Color
@export var point_height : int = 30


@export var is_active_by_default : bool

var current_value : int = 0

func _increase_point(value : int):
	for i in range(0,value):
		get_child(current_value).get_child(0).visible = true
		current_value += 1
	
func _decrease_point(value : int):
	for i in range(0,value):
		current_value -= 1
		get_child(current_value).get_child(0).visible = false
	
func _generate_points():
	for i in range(0, max_point):
		
		var increase_box = CHALLANGE_POINT.instantiate()
		get_transform()
		increase_box.custom_minimum_size = Vector2(get_size().x/max_point, point_height)
		
		var increase_box_style = increase_box.get_theme_stylebox("panel")
		increase_box_style.set("bg_color", border_color)
		increase_box_style.set("border_color", point_color)
		increase_box_style.set_border_width_all(border_width)
		var increase_point : Panel = increase_box.get_child(0)
		
		
		var point_style = increase_point.get_theme_stylebox("panel")
		point_style.set("bg_color", point_color)
		point_style.set("border_color", border_color)
		point_style.set_border_width_all(inner_border_width)
		
		if is_active_by_default:
			increase_box.get_child(0).visible = true
			current_value += 1
		else:
			increase_box.get_child(0).visible = false

		add_child(increase_box)
