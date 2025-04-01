extends Resource
class_name MeleeWeaponResource

@export_category("Melee Stats")
@export var base_damage : int
@export var damage_multiplier : float

@export var base_charge_damage : int
@export var charge_damage_multiplier : float
@export var charge_speed : float

@export var base_range : float = 1
@export var range_multiplier : float

@export var base_attack_speed : float = 1
@export var attack_speed_multiplier : float

@export var ammo_gained : float
@export var collision_polygon : PackedVector2Array

@export_category("Melee Skills")
@export var can_charge : bool
@export var can_precision_charge : bool

func _get_damage():
	return base_damage*damage_multiplier
	
func _get_charge_damage():
	return base_charge_damage*charge_damage_multiplier

func _get_range(target : Sprite2D):
	return Vector2(1,1) * (base_range*range_multiplier)

func _get_attack_speed():
	return base_attack_speed*attack_speed_multiplier
	
	
func _apply_stat(stat_name : String, value : float):
	match stat_name:
		"base_damage":
			base_damage += value
		"damage_multiplier":
			damage_multiplier += value
		"base_charge_damage":
			base_charge_damage += value
		"charge_damage_multiplier":
			charge_damage_multiplier += value
		"charge_speed":
			charge_speed += value
		"base_range":
			base_range += value
		"range_multiplier":
			range_multiplier += value
		"base_attack_speed":
			base_attack_speed += value
		"attack_speed_multiplier":
			attack_speed_multiplier += value
		"ammo_gained":
			ammo_gained += value
		"can_charge":
			can_charge = value == 1
		"can_precision_charge":
			can_precision_charge = value == 1
	
func _apply_charge_speed(animation_tree : AnimationTree):
	animation_tree.set("parameters/ChargeUp/TimeScale/scale", charge_speed)
	
func _apply_attack_speed(animation_tree : AnimationTree, attack_cooldown_timer : Timer, combo_timer : Timer):
#	This only work correctly if all the attack animations are the same length!
	var base_duration = animation_tree.get_animation("DownAttack").length
	var attack_cooldown = base_duration/_get_attack_speed() * (1.2)
	
	animation_tree.set("parameters/Attack/TimeScale/scale", _get_attack_speed())
	animation_tree.set("parameters/Combo/TimeScale/scale", _get_attack_speed())
	attack_cooldown_timer.wait_time = attack_cooldown
	combo_timer.wait_time = attack_cooldown_timer.wait_time * 1.5
	
func _apply_range(target : Sprite2D):
	target.scale = _get_range(target)
	
