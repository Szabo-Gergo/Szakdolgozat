extends BaseEffectStrategy
class_name RootEffectStrategy

const ROOT_EFFECT_COMPONENT = preload("res://Scenes/Components/root_effect_component.tscn")

var duration : float = 3
var root_component : RootEffectComponent
var applied_effects : Array[Node]

func apply_effect(target : Node):
	applied_effects = target.find_children("RootEffectComponent","RootEffectComponent", false, false)
	if applied_effects.is_empty():
		root_component = ROOT_EFFECT_COMPONENT.instantiate()
		root_component.duration = duration
		target.add_child(root_component)
	else:
		applied_effects[0].duration += ceil(applied_effects[0].duration*1.5)

func _to_string() -> String:
	return ""
