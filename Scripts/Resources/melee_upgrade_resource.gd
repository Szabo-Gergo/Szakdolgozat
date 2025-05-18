extends BaseUpgradeResource
class_name MeleeUpgradeResource

@export_enum(
	"damage","range","attack_speed",
	"ammo_gained","status_chance",
) var stat_type : String

func get_stat_type() -> String:
	return stat_type

func set_stat_type(value : String):
	stat_type = value
	
func get_labels() -> Dictionary:
	return {
	"damage": "damage",
	"range": "range",
	"attack_speed": "attack speed",
	"ammo_gained": "ammo gained",
	"status_chance" : "status chance"
	}

func get_upgrade_ranges() -> Dictionary:
	return {
	"damage": {
		"base": Vector2i(3, 10),
		"multiplier": Vector2(1.05, 1.2)
	},
	"range": {
		"multiplier": Vector2(1.05, 1.15),
	},
	"attack_speed": {
		"multiplier": Vector2(1.05, 1.15)
	},
	"ammo_gained": {
		"base": Vector2i(1, 3)
	},
	"status_chance": {
		"multiplier": Vector2(1.5, 1.15)
	}
}
