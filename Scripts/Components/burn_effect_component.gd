extends Node2D
class_name BurnEffectComponent

@export var tick_speed : float
@export var duration : float
@export var damage : int
@export var health_component : Health_Component
var tick_time : float

func _ready() -> void:
	global_position = get_parent().global_position
	health_component = get_parent().health_component  
	tick_time = tick_speed
	
func _process(delta: float) -> void:
	
	tick_time -= delta
	duration -= delta
	if tick_time <= 0:
		health_component.deal_damage(damage)
		tick_time = tick_speed
		
	if duration <= 0: 
		queue_free()
