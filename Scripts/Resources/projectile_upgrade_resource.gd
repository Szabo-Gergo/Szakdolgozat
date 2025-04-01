extends Resource
class_name ProjectileUpgradeResource

@export_enum("damage","speed", "range", "piercing",
			 "multishot","bullet_spread","ammo_cost", "chain") var stat_type : String

@export var value : float

func _to_string() -> String:
	var stat_str : String = ""
	match stat_type:
		"damage":
			stat_str = "+ " + str(value) + " projectile damage"
		"speed":
			stat_str = "+ " + str(int(value * 100)) + "% projectile speed"
		"range":
			stat_str = "+ " + str(int(value * 100)) + "% projectile range"
		"piercing":
			stat_str = "+ " + str(value) + " piercing"
		"multishot":
			stat_str = "+ " + str(value) + " multishot"
		"bullet_spread":
			stat_str = "+ " + str(int(value * 100)) + "% bullet spread"
		"ammo_cost":
			stat_str = "+ " + str(value) + " ammo cost"
		"chain":
			stat_str = "Bounces between enemies "+str(value)+" times"
	return stat_str
