extends BaseUpgradeResource
class_name OutfitUpgradeResource

@export_enum(
	"max_health", "max_armor", "speed",
	"armor_regen_rate", "armor_regen_wait_time",
	"max_dash", "dash_recharge_speed"
) var stat_type: String

func get_stat_type() -> String:
	return stat_type

func set_stat_type(value : String):
	stat_type = value

func get_labels() -> Dictionary:
	return {
		"max_health": "max health",
		"max_armor": "max armor",
		"speed": "speed",
		"armor_regen_rate": "armor regen rate",
		"armor_regen_wait_time": "regen wait",
		"max_dash": "dash count",
		"dash_recharge_speed": "dash recharge"
	}

func get_upgrade_ranges() -> Dictionary:
	return {
		"max_health": {
			"base": Vector2i(5, 30),
			"multiplier": Vector2(1.05, 1.3)
		},
		"max_armor": {
			"base": Vector2i(5, 15),
		},
		"speed": {
			"multiplier": Vector2(1.05, 1.15)
		},
		"armor_regen_rate": {
			"multiplier": Vector2(1.1, 1.5)
		},
		"armor_regen_wait_time": {
			"base": Vector2i(-2.0, -0.1)
		},
		"max_dash": {
			"base": Vector2i(1, 3)
		},
		"dash_recharge_speed": {
			"multiplier": Vector2(1.1, 1.6)
		}
	}
