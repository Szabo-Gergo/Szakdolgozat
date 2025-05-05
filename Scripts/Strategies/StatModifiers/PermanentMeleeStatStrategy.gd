extends BaseStatModifierStrategy
class_name PermanentStatStrategy

@export var upgrades: Array[MeleeUpgradeResource]
@export var is_skill_node : bool

func apply_stat(weapon: Node):
	var resource = weapon.melee_resource
	for upgrade in upgrades:
		var current_value = resource.get(upgrade.stat_type)
		var upgraded_value = current_value * upgrade.value if upgrade.is_multiplier else current_value + upgrade.value
		resource.set(upgrade.stat_type, upgraded_value)
		
		if upgrade.stat_type == "range":
			weapon._update_range()
		elif upgrade.stat_type == "attack_speed":
			weapon._update_attack_speed()
		
func _get_upgrades_string() -> String:
	if upgrades.size() == 1:
		return str(upgrades[0])
		
	var upgrade_str = ""
	for upgrade in upgrades:
		upgrade_str += str(upgrade)+"\n"
	
	return upgrade_str
