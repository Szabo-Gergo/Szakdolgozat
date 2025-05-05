extends Resource
class_name StatusEffects

@export_enum("Burn","Doom","Electric","Root") var status_type : String
@export var status_chance : float = 0
var status_strategy : BaseEffectStrategy
var apply_number : int = 0

func _set_effect_strategy(damage : float):
	if status_type == "None":
		return [null, 0]
	
	apply_number = floor(status_chance) 
	status_strategy = null

	if randf() < (status_chance - apply_number):
		apply_number += 1 
	
	match status_type:
		"Burn":
			status_strategy = BurnEffectStrategy.new()
			print(status_strategy)
			status_strategy.damage = damage / 2
		"Doom":
			status_strategy = DoomEffectStrategy.new()
			status_strategy.damage = damage * 1.75
		"Electric":	
			status_strategy = ElectricEffectStrategy.new()
			status_strategy.damage = damage / 2
		"Root":
			status_strategy = RootEffectStrategy.new()
			
	
func apply_effect(target : Node, damage : float):
	_set_effect_strategy(damage)
	for i in range(0, apply_number):
		status_strategy.apply_effect(target)
