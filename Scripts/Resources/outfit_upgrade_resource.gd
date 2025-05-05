extends Resource
class_name OutfitUpgradeResource

@export_enum(
	"max_health", "max_armor", "speed",
	"armor_regen_rate", "armor_regen_wait_time",
	"max_dash", "dash_recharge_speed"
) var stat_type: String

@export var value: float
@export var is_multiplier: bool

const LABELS = {
	"max_health": "max health",
	"max_armor": "max armor",
	"speed": "speed",
	"armor_regen_rate": "armor regen rate",
	"armor_regen_wait_time": "armor regen delay",
	"max_dash": "dash count",
	"dash_recharge_speed": "dash recharge"
}

func _to_string() -> String:
	return format_stat(LABELS.get(stat_type, "Invalid stat type"))

func format_stat(label: String) -> String:
	if is_multiplier:
		var percent = int((value - 1.0) * 100)
		return "%s%d%% %s" % ["+" if percent >= 0 else "", percent, label]
	else:
		return "%s%.2f %s" % ["+" if value >= 0 else "", value, label]
