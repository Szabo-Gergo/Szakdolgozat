extends BaseStatModifierStrategy
class_name TemporaryProjectileStatStrategy

@export var upgrades: Array[ProjectileUpgradeResource]
@export var duration: float

func apply_stat(target: Node):
	for upgrade in upgrades:
		target.apply_upgrade(upgrade.stat_type, upgrade.value, false)
		target.get_tree().create_timer(duration).timeout.connect(func(): remove_stat(target))

func remove_stat(target : Node):
	for upgrade in upgrades:
		target.apply_upgrade(upgrade.stat_type, -upgrade.value, 0, false)

func _get_upgrades_string():
	if upgrades.size() == 1:
		return str(upgrades[0])
		
	var upgrade_str = ""
	for upgrade in upgrades:
		upgrade_str += str(upgrade)+"\n"
	
	upgrade_str += " for " + str(duration) + " seconds"
	
	return upgrade_str
