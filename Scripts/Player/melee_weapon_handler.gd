extends Node2D


const SWORD_SPRITES = preload("res://Spritesheets/Weapon/Sword_With_Charge.png")
const SWORD_TRAIL = preload("res://Spritesheets/Weapon/Sword_Trail.png")
const SWORD_STATS = preload("res://Resources/Sword_Stats.tres")

const SPEAR_SPRITES = preload("res://Spritesheets/Weapon/Spear_sprites.png")
const SPEAR_TRAIL = preload("res://Spritesheets/Weapon/Spear_Trail.png")
const SPEAR_STATS = preload("res://Resources/Spear_Stats.tres")

const HAMMER_SPRITES = preload("res://Spritesheets/Weapon/Hammer_sprites.png")
const HAMMER_TRAIL = preload("res://Spritesheets/Weapon/Hammer_Trail.png")
const HAMMER_STATS = preload("res://Resources/Hammer_Stats.tres")


var weapon_setup_data = {
	0: {
		"stats": SWORD_STATS,
		"texture": SWORD_SPRITES,
		"trail_texture": SWORD_TRAIL,
		"offset": Vector2(10, 0),  # Offset applied to both sprite and hitbox
	},
	1: {
		"stats": HAMMER_STATS,
		"texture": HAMMER_SPRITES,
		"trail_texture": HAMMER_TRAIL,
		"offset": Vector2(10, 0),
	},
	2: {
		"stats": SPEAR_STATS,
		"texture": SPEAR_SPRITES,
		"trail_texture": SPEAR_TRAIL,
		"offset": Vector2(15, 0),
	}
}



@export_category("Weapons")
@export var weapon_sprite : Sprite2D
@export var hitbox : CollisionPolygon2D
@export var trail_sprite : Sprite2D
@export var melee_resource : MeleeWeaponResource
@onready var player: CharacterBody2D = $".."
var current_weapon_index : int 
#0 -> SWORD, 1 -> Hammer, 2 -> Spear
func _on_weapon_change(weapon_index : int):
	if weapon_index in weapon_setup_data:
		var data = weapon_setup_data[weapon_index]
		
		melee_resource = data["stats"]
		weapon_sprite.texture = data["texture"]
		trail_sprite.texture = data["trail_texture"]
		trail_sprite.offset = data["offset"]
		current_weapon_index = weapon_index
	weapon_sprite.hframes = 11
	weapon_sprite.vframes = 1
