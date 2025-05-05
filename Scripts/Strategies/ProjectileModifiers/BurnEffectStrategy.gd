extends BaseEffectStrategy
class_name BurnEffectStrategy

const BURN_EFFECT_COMPONENT = preload("res://Scenes/Components/burn_effect_component.tscn")

var tick_speed : float = 0.5
var duration : float = 4
var damage : int = 2
var burn_component : BurnEffectComponent
var applied_effects : Array[Node]

func apply_effect(target : Node):
	applied_effects = target.find_children("BurnEffectComponent","BurnEffectComponent", false, false)
	if applied_effects.is_empty():
		burn_component = BURN_EFFECT_COMPONENT.instantiate()
		burn_component.damage = damage
		burn_component.duration = duration
		burn_component.tick_speed = tick_speed
		target.add_child(burn_component)
	else:
		applied_effects[0].damage += applied_effects[0].damage/2
		applied_effects[0].duration += duration/2
	

func _to_string() -> String:
	return ""
