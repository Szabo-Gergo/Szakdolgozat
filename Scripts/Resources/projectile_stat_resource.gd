extends Resource
class_name ProjectileStatResource

@export var weapon_name : String
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


func get_weapon_string() -> Dictionary:
	var output : Dictionary = {
		"name" : weapon_name,
		"base_stats" : _get_base_stat_string(),
		"effects" : _get_effects_string(),
	}
	return output
	
func _get_base_stat_string() -> String:
	return "Damage: %d\nSpeed: %d\nRange: %d\nAmmo Cost: %.1f\nBullet Spread: %d°" % [
		damage,
		speed,
		range,
		ammo_cost,
		bullet_spread,
	]
	
func _get_effects_string() -> String:
	var exp_string : String = ""
	if can_explode:
		exp_string = "Explosive bullets\nExplosion Range: "+str(explosion_range)
	
	return "Piercing: %d\nMultishot: %d\nBullet bounce: %d\nBullet Spread: %.2f°\n%s" %[
	piercing,
	multishot,
	chain,
	bullet_spread,
	exp_string
	]
