extends Resource
class_name ProjectileStatResource

@export_range(100,1000) var speed: float 
@export var damage: int 
@export var range: float
@export var piercing: int
@export var multishot: float
@export var bullet_spread: float
@export var ammo_cost : float
@export var chain : int

func _apply_stat(stat_type : String, value):
	match stat_type:
		"damage":
			damage += value
		"speed":
			speed += value
		"range":
			range += value
		"piercing":
			piercing += value
		"multishot":
			multishot += value
			bullet_spread += 5
		"bullet_spread":
			bullet_spread += value
		"ammo_cost":
			ammo_cost += value
		"chain":
			chain += value
			piercing += value
