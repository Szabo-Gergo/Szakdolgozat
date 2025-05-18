extends Node2D
class_name MenuInteractionComponent


@export var is_interactive_tile : bool = false
@export var area_range : int
@export var menu: Control
@export var sprite : Sprite2D

@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var label: Label = $Label
var check_for_input : bool



func _ready() -> void:
	check_for_input = false
	var interact_event = InputMap.action_get_events("interact")[0]	
	label.text = "["+InputMap.action_get_events("interact")[0].as_text()+"] Interact"
	collision_shape_2d.shape.set("radius", area_range)
	

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		label.visible = true
		sprite.material.set("shader_parameter/pixel_size", 1)
		check_for_input = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		label.visible = false
		sprite.material.set("shader_parameter/pixel_size", 0)
		check_for_input = false
		menu.get_parent().hide()
		
func _input(event: InputEvent) -> void:
	if check_for_input and (event.is_action_pressed("interact") or (get_tree().paused and event.is_action_pressed("menu_exit"))):
		if !get_tree().paused:
			menu.get_parent().show()
			get_tree().paused = true
		elif get_tree().paused:
			get_tree().paused = false
			menu.get_parent().hide()
	
