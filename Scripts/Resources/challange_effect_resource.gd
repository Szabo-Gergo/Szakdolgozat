extends Resource
class_name ChallangeEffectResource

@export_enum("enemy_armor","enemy_health","enemy_speed",
			 "elite_chance","enemy_spawn","glass_cannon",
			 "player_tank") var effect_type : String

@export var current_value : float

func _to_string() -> String:
	var effect_str : String = ""
	match effect_type:
		"enemy_armor":
			effect_str = "+ " + str(int(current_value * 100)) + "% enemy armor"
		"enemy_health":
			effect_str = "+ " + str(int(current_value * 100)) + "% enemy health"
		"enemy_speed":
			effect_str = "+ " + str(int(current_value * 100)) + "% enemy speed"
		"elite_chance":
			effect_str = "+ " +  str(int(current_value * 100)) + "% elite chance"
		"enemy_spawn":
			effect_str = "+ " + str(int(current_value * 100)) + "% enemy spawn rate"
		"glass_cannon":
			effect_str = "Doubles damage but -75% health"
		"player_tank":
			effect_str = "Doubles health but -50% damage"
	
	return effect_str
