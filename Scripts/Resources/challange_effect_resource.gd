extends Resource
class_name ChallangeEffectResource

@export_enum("enemy_armor","enemy_health","enemy_speed",
			 "elite_chance","enemy_spawn","player_glass_cannon",
			 "player_player_tank") var effect_type : String
			
@export var value : float

func _to_string() -> String:
	var effect_str : String = ""
	match effect_type:
		"enemy_armor":
			effect_str = "+ " + str(int(value * 100)) + "% enemy armor"
		"enemy_health":
			effect_str = "+ " + str(int(value * 100)) + "% enemy health"
		"enemy_speed":
			effect_str = "+ " + str(int(value * 100)) + "% enemy speed"
		"elite_chance":
			effect_str = "+ " +  str(int(value * 100)) + "% elite chance"
		"enemy_spawn":
			effect_str = "+ " + str(int(value * 100)) + "% enemy spawn rate"
		"player_glass_cannon":
			effect_str = "Doubles base damage but -80% health"
		"player_tank":
			effect_str = "Doubles max health but -50% speed"

	
	return effect_str
