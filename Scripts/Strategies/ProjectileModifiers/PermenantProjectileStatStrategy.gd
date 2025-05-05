extends BaseStatModifierStrategy
class_name PermenantProjectileStatStrategy

@export var upgrades: Array[ProjectileUpgradeResource]

func apply_stat(projectile: Node):
	var resource = projectile.projectile_resource
	for upgrade in upgrades:
		var current_value = resource.get(upgrade.stat_type)
		var upgraded_value = current_value * upgrade.value if upgrade.is_multiplier else current_value + upgrade.value
		resource.set(upgrade.stat_type, upgraded_value)

func _get_upgrades_string() -> String:
	if upgrades.size() == 1:
		return str(upgrades[0])
		
	var upgrade_str = ""
	for upgrade in upgrades:
		upgrade_str += str(upgrade)+"\n"
	
	return upgrade_str
