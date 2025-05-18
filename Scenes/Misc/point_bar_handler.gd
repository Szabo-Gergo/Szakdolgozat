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
	for i in range(value):
		if current_value < max_point and current_value < get_child_count():
			get_child(current_value).get_child(0).visible = true
			current_value += 1

func _decrease_point(value : int):
	for i in range(value):
		if current_value > 0 and current_value - 1 < get_child_count():
			current_value -= 1
			get_child(current_value).get_child(0).visible = false

func _generate_points():
	# Clear old points
	for child in get_children():
		child.queue_free()
	current_value = 0

	# Create new ones
	for i in range(max_point):
		var box = CHALLANGE_POINT.instantiate()
		box.custom_minimum_size = Vector2(get_size().x / max_point, point_height)

		var box_style = box.get_theme_stylebox("panel")
		box_style.set("bg_color", border_color)
		box_style.set("border_color", point_color)
		box_style.set_border_width_all(border_width)

		var point = box.get_child(0)
		var point_style = point.get_theme_stylebox("panel")
		point_style.set("bg_color", point_color)
		point_style.set("border_color", border_color)
		point_style.set_border_width_all(inner_border_width)

		point.visible = is_active_by_default
		if is_active_by_default:
			current_value += 1

		add_child(box)
