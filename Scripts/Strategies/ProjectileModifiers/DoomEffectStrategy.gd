extends BaseEffectStrategy
class_name DoomEffectStrategy

const DOOM_EFFECT_COMPONENT = preload("res://Scenes/Components/doom_effect_component.tscn")

var charge_duration : float = 5
var damage : int = 5
var doom_component : DoomEffectComponent
var applied_effects : Array[Node]

func apply_effect(target : Node):
	applied_effects = target.find_children("DoomEffectComponent","DoomEffectComponent", false, false)
	if applied_effects.is_empty():
		doom_component = DOOM_EFFECT_COMPONENT.instantiate()
		doom_component.damage = damage
		doom_component.charge_duration = charge_duration
		target.add_child(doom_component)
	else:
		applied_effects[0].damage *= 1.1
		applied_effects[0].charge_duration += charge_duration/2

func _to_string() -> String:
	return ""
