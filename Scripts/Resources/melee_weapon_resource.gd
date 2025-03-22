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

@export_category("Melee Skills")
@export var can_charge : bool
@export var can_precision_charge : bool


func _get_damage():
	return base_damage*damage_multiplier
	
func _get_charge_damage():
	return base_charge_damage*charge_damage_multiplier

func _get_range():
	return base_range*range_multiplier

func _get_attack_speed():
	return base_attack_speed*attack_speed_multiplier
	
