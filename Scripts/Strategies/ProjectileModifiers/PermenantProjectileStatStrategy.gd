extends BaseStatModifierStrategy
class_name PermenantProjectileStatStrategy

@export var upgrades: Array[ProjectileUpgradeResource]

func apply_stat(ranged_weapon: Node, is_remove : bool = false):
	var resource = ranged_weapon.projectile_resource
	for upgrade in upgrades:
		if upgrade.stat_type == "can_explode":
			resource.set(upgrade.stat_type, true)
			resource.set("explosion_range", 15)
			continue
			
		var current_value = resource.get(upgrade.stat_type)
		var upgraded_value 
		
		if is_remove and (current_value != 0 and upgrade.value != 0):
			upgraded_value = current_value / upgrade.value if upgrade.is_multiplier else current_value - upgrade.value
		elif !is_remove:
			upgraded_value = current_value * upgrade.value if upgrade.is_multiplier else current_value + upgrade.value

		resource.set(upgrade.stat_type, upgraded_value)

func _to_string() -> String:
	if upgrades.size() == 1:
		return str(upgrades[0])
		
	var upgrade_str = ""
	for upgrade in upgrades:
		upgrade_str += str(upgrade)+"\n"
	
	return upgrade_str
