extends BaseUpgradeResource
class_name ProjectileUpgradeResource

@export_enum(
	"damage","speed", "range", "piercing",
	 "multishot","bullet_spread","ammo_cost", 
	 "chain", "can_explode","explosion_range"
) var stat_type : String


func get_stat_type() -> String:
	return stat_type

func set_stat_type(value : String):
	stat_type = value

func get_labels() -> Dictionary:
	return {
	"damage": "projectile damage",
	"speed": "projectile speed",
	"range": "range",
	"piercing": "piercing",
	"multishot" : "multishot",
	"bullet_spread" : "projectile spread",
	"ammo_cost" : "ammo cost",
	"chain" : "projectile bounce",
	"can_explode" : "projectiles explode",
	"explosion_range" : "explosion range"
}

func get_upgrade_ranges() -> Dictionary:
	return {
	"damage": {
		"base": Vector2i(3, 10),
		"multiplier": Vector2(1.05, 1.2)
	},
	"speed":{
		"multiplier": Vector2(1.05, 1.25)
	},
	"range": {
		"multiplier": Vector2(1.05, 1.25),
	},
	"piercing": {
		"base": Vector2i(1, 3)
	},
	"multishot": {
		"base": Vector2i(1, 3)
	},
	"bullet_spread": {
		"multiplier": Vector2(1.1, 1.4)
	},
	"ammo_cost": {
		"multiplier": Vector2(1.1,1.2)
	},
	"chain": {
		"base":  Vector2i(1,3)
	},
	"can_explode": {
		"base" : Vector2i(1,1)
	},
	"explosion_range":{
		"multiplier": Vector2(1.1, 1.35)
	}
}


func format_stat(label: String) -> String:
	if label == "projectiles explode":
		return label 
	return super.format_stat(label)
