extends Node
class_name RangedWeapon

const PISTOL_SPRITE = preload("res://Spritesheets/Weapon/Pistol_Sprite.png")
const PISTOL_STATS = preload("res://Resources/RangedWeaponStats/Pistol_Stats.tres")

const SHOTGUN_SPRITE = preload("res://Spritesheets/Weapon/Shotgun_Sprite.png")
const SHOTGUN_STATS = preload("res://Resources/RangedWeaponStats/shotgun_stats.tres")

const FLAME_THROWER_SPRITE = preload("res://Spritesheets/Weapon/FlameThrower_Sprite.png")
const FLAMETHROWER_STATS = preload("res://Resources/RangedWeaponStats/flamethrower_stats.tres")

const ROCKET_SPRITE = preload("res://Spritesheets/Weapon/Rocket_Sprite.png")
const ROCKET_STATS = preload("res://Resources/RangedWeaponStats/rocket_stats.tres")


@export var max_ammo : int = 1
@export var projectile_resource : ProjectileStatResource
@export var player : Player
@onready var weapon_sprite: Sprite2D = $Weapon
@onready var shoot_component: ShootComponent = $"../State Machine/Shoot/ShootComponent"

func _ready() -> void:
	_on_weapon_change(player.base_stats.ranged_weapon_type)
	
func _on_weapon_change(weapon_index : int):
	match weapon_index:
		0:
			weapon_sprite.texture = PISTOL_SPRITE
			projectile_resource = PISTOL_STATS
			shoot_component.is_aoe = false
		1:
			weapon_sprite.texture = SHOTGUN_SPRITE
			projectile_resource = SHOTGUN_STATS
			shoot_component.is_aoe = true
		2:
			weapon_sprite.texture = FLAME_THROWER_SPRITE
			projectile_resource = FLAMETHROWER_STATS
			shoot_component.is_aoe = false
		3:
			weapon_sprite.texture = ROCKET_SPRITE
			projectile_resource = ROCKET_STATS
			shoot_component.is_aoe = false
			
	RuntimeSaves.player_stats.ranged_weapon_type = weapon_index
	RuntimeSaves.save_resources()

func _get_projectile_resource():
	return projectile_resource

func get_weapon_string() -> Dictionary:
	var out = {
		"name" : "",
		"base_stats" : "",
		"effects" : ""
	}
	return out
