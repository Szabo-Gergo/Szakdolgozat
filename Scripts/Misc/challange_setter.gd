extends Control
signal update_buff_label

@export var challange_title : String
@export var max_challange_amount : int
@export var challange_effect : ChallangeEffectResource
@export var challange_increase_per_level : float
@export var material_gain_buff_per_level : float
@onready var point_container: PointContainer = %PointContainer
@onready var challange_value_label: Label = $MarginContainer/HBoxContainer/ChallangeValueLabel
const CHALLANGE_POINT = preload("res://Scenes/UI/challange_point.tscn")


var challange_value : float = 0
var challange_level : int = 0

func _ready() -> void:
	%ChallangeTitle.text = challange_title
	challange_value_label.text = "+"+str(challange_effect.value*challange_level*100)+"%"
	point_container.max_point = max_challange_amount
	point_container._generate_points()

func _on_increase_pressed() -> void:
	if challange_level < max_challange_amount:
		point_container._increase_point(1)
		challange_effect.value += challange_increase_per_level
		challange_value_label.text = "+"+str(challange_effect.value*100)+"%"
		challange_level += 1
		update_buff_label.emit(material_gain_buff_per_level)
		
func _on_decrease_pressed() -> void:
	if challange_level > 0:
		point_container._decrease_point(1)
		challange_effect.value -= challange_increase_per_level
		challange_value_label.text = "+"+str(challange_effect.value*100)+"%"
		challange_level -= 1
		update_buff_label.emit(-material_gain_buff_per_level)


func _get_challange_effect() -> ChallangeEffectResource:
	return challange_effect
