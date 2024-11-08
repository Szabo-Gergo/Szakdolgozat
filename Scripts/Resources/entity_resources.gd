extends Resource
class_name BaseStats

@export var damage : int : set = _set_damage, get = _get_damage
@export var max_health : int : set = _set_max_health, get = _get_max_health
@export var speed : float : set = _set_speed, get = _get_speed

func _set_damage(new_damage):
	damage = new_damage
	
func _get_damage():
	return damage

func _set_max_health(new_max_health):
	max_health = new_max_health

func _get_max_health():
	return max_health
	
func _set_speed(new_speed):
	speed = new_speed
	
func _get_speed():
	return speed
