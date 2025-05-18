extends BaseStatModifierStrategy
class_name PermenantOutfitStatStrategy

var upgrades : Array[OutfitUpgradeResource]

func apply_stat(target : Node, is_remove : bool = false) -> void:
	var resource = target.outfit_resource
	if upgrades.is_empty():
		return
		
	for upgrade in upgrades:
		var current_value = resource.get(upgrade.stat_type)
		var upgraded_value
		
		if is_remove and (current_value != 0 and upgrade.value != 0):
			upgraded_value = current_value / upgrade.value if upgrade.is_multiplier else current_value - upgrade.value
		elif !is_remove:
			upgraded_value = current_value * upgrade.value if upgrade.is_multiplier else current_value + upgrade.value

		resource.set(upgrade.stat_type, upgraded_value)
		target.ui_change()


func _to_string() -> String:
	if upgrades.size() == 1:
		return str(upgrades[0])
		
	var upgrade_str = ""
	for upgrade in upgrades:
		upgrade_str += str(upgrade)+"\n"
	
	return upgrade_str
