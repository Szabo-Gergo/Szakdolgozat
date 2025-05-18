extends Resource
class_name BaseUpgradeResource

@export var value: float
@export var is_multiplier: bool
@export var rarity : RARITY
enum RARITY {COMMON, RARE, EPIC, LEGENDARY}

func get_labels() -> Dictionary:
	return {}

func get_upgrade_ranges() -> Dictionary:
	return {}

func get_stat_type() -> String:
	return ""

func set_stat_type(value : String):
	pass

func get_random_stat_type() -> String:
	var keys = get_labels().keys()
	var random_key = keys[randi() % keys.size()]
	set_stat_type(random_key)
	return random_key
	
func generate_random_upgrade(is_negative: bool = false) -> void:
	var stat_ranges = get_upgrade_ranges().get(get_random_stat_type(), null)
	if stat_ranges == null:
		print("Stat type '%s' not found in upgrade ranges." % get_random_stat_type())
		return

	var has_base = stat_ranges.has("base")
	var has_multiplier = stat_ranges.has("multiplier")

	if has_base and has_multiplier:
		is_multiplier = randi() % 2 == 0
	elif has_base:
		is_multiplier = false
	elif has_multiplier:
		is_multiplier = true

	if is_multiplier:
		var range = stat_ranges["multiplier"]
		var rarity_range = get_rarity_scaled_range(range, false)
		var raw_val = randf_range(rarity_range.x, rarity_range.y)
		value = 2 - raw_val if is_negative else raw_val
	else:
		var range = stat_ranges["base"]
		var rarity_range = get_rarity_scaled_range(range, true)
		var raw_val = randi_range(rarity_range.x, rarity_range.y)
		value = -raw_val if is_negative else raw_val

func get_rarity_scaled_range(range, is_base : bool):
	var min_val = range.x
	var max_val = range.y
	var diff = max_val - min_val
	
	match rarity:
		RARITY.COMMON:
			max_val = min_val + diff / 3.0
		RARITY.RARE:
			min_val += diff / 3.0
			max_val = min_val + diff / 3.0
		RARITY.EPIC:
			min_val += (diff * 2.0 / 3.0)
		RARITY.LEGENDARY:
			min_val = max_val

	if is_base:
		return Vector2i(round(min_val), round(max_val))
	else:
		return Vector2(min_val, max_val)


func _to_string() -> String:
	return format_stat(get_labels().get(get_stat_type(), "Invalid stat type"))

func format_stat(label: String) -> String:
	if is_multiplier:
		var percent = int((value - 1.0) * 100)
		var sign = "+" if percent >= 0 else ""
		return "%s%d%% %s" % [sign, percent, label]
	else:
		var sign = "+" if value >= 0 else ""
		return "%s%s %s" % [sign, value, label]
