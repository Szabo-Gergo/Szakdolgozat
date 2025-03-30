extends BaseStatModifierStrategy
class_name PermanentStatStrategy

@export var upgrades: Array[UpgradeResource]
@export var is_skill_node : bool

func apply_stat(weapon: Node):
	for upgrade in upgrades:
		weapon.apply_upgrade(upgrade.stat_type, upgrade.value, is_skill_node)

func _get_upgrades_string() -> String:
	if upgrades.size() == 1:
		return str(upgrades[0])
		
	var upgrade_str = ""
	for upgrade in upgrades:
		upgrade_str += str(upgrade)+"\n"
	
	return upgrade_str
