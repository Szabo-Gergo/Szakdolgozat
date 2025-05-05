extends BaseEffectStrategy
class_name ElectricEffectStrategy

const ELECTRIC_EFFECT_COMPONENT = preload("res://Scenes/Components/electric_effect_component.tscn")

var damage : int = 2
var electric_component : ElectricEffectComponent
var applied_effects : Array[Node]

func apply_effect(target : Node):
	applied_effects = target.find_children("ElectricEffectComponent","ElectricEffectComponent", false, false)
	if applied_effects.is_empty():
		electric_component = ELECTRIC_EFFECT_COMPONENT.instantiate()
		electric_component.damage = damage
		target.add_child(electric_component)
	else:
		applied_effects[0].damage += ceil(applied_effects[0].damage*1.5)

func _to_string() -> String:
	return ""
