extends Resource
class_name UpgradeResource

@export_enum(	"base_damage","damage_multiplier",
				"base_charge_damage","charge_damage_multiplier",
				"charge_speed","base_range","range_multiplier",
				"base_attack_speed","attack_speed_multiplier","ammo_gained",
				"can_charge","can_precision_charge") var stat_type : String
 
@export var value : float

func _to_string() -> String:
	var stat_str : String = ""
	match stat_type:
		"base_damage":
			stat_str = "+ " + str(value) + " damage"
		"damage_multiplier":
			stat_str = "+ " + str(int(value * 100)) + "% damage"
		"base_charge_damage":
			stat_str = "+ " + str(value) + " charge damage"
		"charge_damage_multiplier":
			stat_str = "+ " + str(int(value * 100)) + "% charge damage"
		"charge_speed":
			stat_str = "+ " + str(value) + " charge speed"
		"base_range":
			stat_str = "+ " + str(value) + " range"
		"range_multiplier":
			stat_str = "+ " + str(int(value * 100)) + "% range"
		"base_attack_speed":
			stat_str = "+ " + str(value) + " attack speed"
		"attack_speed_multiplier":
			stat_str = "+ " + str(int(value * 100)) + "% attack speed"
		"ammo_gained":
			stat_str = "+ " + str(int(value)) + " ammo"
		"can_charge":
			if value == 1:
				stat_str = "Unlocks charge attack"
			elif value == 0:
				stat_str = "Removes charge attacks"
		"can_precision_charge":
			if value == 1:
				stat_str = "Unlocks precision charge"
			elif value == 0:
				stat_str = "Removes charge attacks"
					
			
	return stat_str
