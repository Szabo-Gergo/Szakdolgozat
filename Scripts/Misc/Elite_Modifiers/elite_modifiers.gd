extends Node
class_name EliteModifiers

enum ELITE_TYPES {
	STRONG,			# +armor, +damage (orange??)
	FAST,			# +speed, +attack_speed -size(red)
	TANKY,			# ++health +armor -speed +size (blue)
	HEALER			# +healing enemies arount itself (green)
}

var elite_modifiers = {
	ELITE_TYPES.STRONG: {"damage_multiplier": 1.5, "armor_multiplier" : 1.3, "color": "b87937"},
	ELITE_TYPES.FAST: { "speed_multiplier": 1.75, "attack_speed_multiplier" : 1.75, "size_multiplier" : 0.7, "color": "ff4141"},
	ELITE_TYPES.TANKY: { "health_multiplier": 2.0, "armor_multiplier": 1.5, "speed_multiplier" : 0.9, "size_multiplier": 1.2, "color": "0087ff"},
	ELITE_TYPES.HEALER: { "regen_rate": 5, "regen_range": 10, "regen_amount": 4, "color": "00f64a"}
}

func apply_elite_modifiers(enemy, elite_type):
	if elite_type in elite_modifiers and enemy.has_method("apply_modifier"):
		enemy.apply_modifier(elite_type, elite_modifiers[elite_type])
