extends Resource
class_name ProjectileUpgradeResource

@export_enum("damage","speed", "range", "piercing",
			 "multishot","bullet_spread","ammo_cost", "chain") var stat_type : String
			
@export var is_multiplier : bool
@export var value : float

const LABELS = {
	"damage": "projectile damage",
	"speed": "projectile speed",
	"range": "range",
	"piercing": "piercing",
	"multishot" : "multishot",
	"bullet_spread" : "projectile spread",
	"ammo_cost" : "ammo cost",
	"chain" : "projectiles bounce between enemies"
}

func _to_string() -> String:
	return format_stat(LABELS.get(stat_type, "Invalid stat type"))

func format_stat(label: String) -> String:
	if is_multiplier:
		var percent = int((value - 1.0) * 100)
		return "%s%d%% %s" % ["+" if percent >= 0 else "", percent, label]
	else:
		return "%s%.2f %s" % ["+" if value >= 0 else "", value, label]
