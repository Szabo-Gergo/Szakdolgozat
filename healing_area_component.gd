extends Area2D
class_name Healing_Area

@export var range : int
@export var rate : int
@export var amount : int
@onready var heal_shape: CollisionShape2D = $HealShape
@onready var heal_timer: Timer = $HealTimer

var heal_list : Array[Base_Enemy]

func set_healing_range(value: int) -> void:
		range = value
		heal_shape.shape.radius = range

func set_healing_rate(value: int) -> void:
		rate = value
		heal_timer.wait_time = rate

func set_healing_amount(value: int) -> void:
		amount = value

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		heal_list.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		heal_list.erase(body)

func _on_heal_timer_timeout() -> void:
	for body in heal_list:
		body.health_component.healing(amount)
		
