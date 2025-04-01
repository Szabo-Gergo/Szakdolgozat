extends BaseStatModifierStrategy
class_name PermenantProjectileStatStrategy

@export var upgrades: Array[ProjectileUpgradeResource]

func apply_stat(projectile: Node):
	for upgrade in upgrades:
		projectile.apply_upgrade(upgrade.stat_type, upgrade.value)

func _get_upgrades_string() -> String:
	if upgrades.size() == 1:
		return str(upgrades[0])
		
	var upgrade_str = ""
	for upgrade in upgrades:
		upgrade_str += str(upgrade)+"\n"
	
	return upgrade_str
