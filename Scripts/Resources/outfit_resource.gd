extends BaseStats
class_name OutfitResource

#@export var damage : int 
#@export var max_health : int 
#@export var max_armor : int 
#@export var speed : int 

@export var outfit_name : String
@export var armor_regen_rate : float
@export var armor_regen_wait_time : float
@export var max_dash : int
@export var dash_recharge_speed : float
@export var max_ammo : int
@export var melee_upgrades : PermanentMeleeStatStrategy
@export var ranged_upgrades : PermenantProjectileStatStrategy

func get_outfit_string() -> Dictionary:
	var output : Dictionary = {
		"name" : outfit_name,
		"base_stats" : _get_base_stat_string(),
		"melee_upgrades" : melee_upgrades.to_string(),
		"ranged_upgrades" : ranged_upgrades.to_string(), 
	}
	return output

func _get_base_stat_string() -> String:
	return "Health: %d\nSpeed: %d\nArmor: %d\nMax Ammo%d\nArmor Regen Rate: %.2f/sec\nArmor Regen Cooldown: %.2fs\nDashes: %d\nDash Recharge Speed: %.2f/sec" % [
		max_health,
		speed,
		max_armor,
		max_ammo,
		armor_regen_rate,
		armor_regen_wait_time,
		max_dash,
		dash_recharge_speed
	]
