extends Resource
class_name MeleeWeaponResource

@export_category("Melee Stats")
@export var damage : int
@export var range : float = 1
@export var attack_speed : float = 1
@export var ammo_gained : float
@export var collision_polygon : PackedVector2Array
@export var status_effect : StatusEffects
