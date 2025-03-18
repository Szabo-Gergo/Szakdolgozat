extends Node2D
class_name InteractionComponent
#Used for interactable objects that open menu
@export var sprite : Sprite2D
@export var area_range : int
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
		print("Player Entered!")



func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		label.visible = false
		sprite.material.set("shader_parameter/pixel_size", 0)
		check_for_input = false
		print("Player Left!")
		#Close the pop up menu
		
func _input(event: InputEvent) -> void:
	if check_for_input and event.is_action_pressed("interact"):
		print("Menu will be opened!")
		pass
