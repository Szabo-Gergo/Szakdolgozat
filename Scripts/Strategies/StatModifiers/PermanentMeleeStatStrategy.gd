extends BaseStatModifierStrategy
class_name PermanentMeleeStatStrategy

@export var upgrades: Array[MeleeUpgradeResource]
@export var is_skill_node : bool

func apply_stat(weapon: Node, is_remove : bool = false):
	var resource = weapon.melee_resource
	if upgrades.is_empty():
		return
		
	for upgrade in upgrades:
		var current_value 
		
		if upgrade.stat_type == "status_chance":
			current_value = resource.status_effect.get(upgrade.stat_type)
		else:
			current_value = resource.get(upgrade.stat_type)
			
		var upgraded_value
		
		if is_remove and (current_value != 0 and upgrade.value != 0):
			upgraded_value = current_value / upgrade.value if upgrade.is_multiplier else current_value - upgrade.value
		elif !is_remove:
			upgraded_value = current_value * upgrade.value if upgrade.is_multiplier else current_value + upgrade.value

		if upgrade.stat_type == "status_chance":
			resource.status_effect.set(upgrade.stat_type, upgraded_value)
		else:
			resource.set(upgrade.stat_type, upgraded_value)
		
		if upgrade.stat_type == "range":
			weapon._update_range()
		elif upgrade.stat_type == "attack_speed":
			weapon._update_attack_speed()
	
func _to_string() -> String:
	if upgrades.size() == 1:
		return str(upgrades[0])
		
	var upgrade_str = ""
	for upgrade in upgrades:
		upgrade_str += str(upgrade)+"\n"
	
	return upgrade_str
