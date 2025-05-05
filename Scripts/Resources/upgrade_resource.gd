extends Resource
class_name MeleeUpgradeResource

@export_enum("damage","range","attack_speed",
			"ammo_gained","status_chance",
			) var stat_type : String

@export var is_multiplier : bool 
@export var value : float


const LABELS = {
	"damage": "damage",
	"range": "range",
	"attack_speed": "attack speed",
	"ammo_gained": "ammo gained",
	"status_chance" : "status chance"
}

func _to_string() -> String:
	return format_stat(LABELS.get(stat_type, "Invalid stat type"))

func format_stat(label: String) -> String:
	if is_multiplier:
		var percent = int((value - 1.0) * 100)
		return "%s%d%% %s" % ["+" if percent >= 0 else "", percent, label]
	else:
		return "%s%.2f %s" % ["+" if value >= 0 else "", value, label]
