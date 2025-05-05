extends Resource
class_name ProjectileStatResource

@export var sprite_frames : SpriteFrames
@export var is_flamethrower : bool
@export var status_effect : StatusEffects
@export_enum("bullet","firework") var animation_name : String
 
@export_range(100,1000) var speed: float 
@export var damage : int
@export var range : float
@export var piercing : int
@export var multishot : float = 1
@export var bullet_spread : float
@export var ammo_cost : float
@export var chain : int
@export_category("Explosive")
@export var can_explode : bool
@export var explosion_damage_multipler : float
@export var explosion_range : int
@export_category("Force Field")
@export var has_force_field : bool
@export var force_range : int
@export var force_strength : int
@export var force_is_pulling : bool

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
		"can_explode":
			can_explode = true
			explosion_range = 50
			explosion_damage_multipler = 1
		"explosion_damage_multipler":
			explosion_damage_multipler += value
		"explosion_range":
			explosion_range += value
			
