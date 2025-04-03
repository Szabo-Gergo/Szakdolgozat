extends Node
class_name RangedWeapon

const PISTOL = preload("uid://dqr0jcospxssv")
const PISTOL_STATS = preload("res://Resources/RangedWeaponStats/Pistol_Stats.tres")

@export var projectile_resource : ProjectileStatResource
@onready var weapon_sprite: Sprite2D = $Weapon
@export var modifiers: Array[BaseStatModifierStrategy]

func _on_weapon_change(weapon_index : int):
	match weapon_index:
		0:
			weapon_sprite.texture = PISTOL
			projectile_resource = PISTOL_STATS
		1:
			pass
		2:
			pass

func _get_projectile_resource():
	return projectile_resource
	
