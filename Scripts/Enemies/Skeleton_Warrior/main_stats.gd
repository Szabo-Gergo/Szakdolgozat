extends CharacterBody2D
class_name Base_Enemy

@export_category("Enemy Stats")
@export var base_stats : BaseStats
var health : int

func _ready() -> void:
	health = base_stats._get_max_health()

func _add_health(new_health):
	var max_health = base_stats._get_max_health()
	
	health += new_health
	if health >= max_health:
		health = max_health
	elif health <= 0:
		health = 0
