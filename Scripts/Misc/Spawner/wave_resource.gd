extends Resource
class_name WaveResource

@export var enemy_info: Array[SpawnInfo]  # Regular enemies
@export var duration: float  # Time limit for the wave
@export var is_filler_wave: bool = false  # Filler wave is what starts 

func _get_spawn_amount():
	var sum = 0
	for info in enemy_info:
		sum += info.spawn_amount
	return sum
