extends Node2D
class_name MeleeWeapon

const SWORD_SPRITES = preload("res://Spritesheets/Weapon/Sword_With_Charge.png")
const SWORD_TRAIL = preload("res://Spritesheets/Weapon/Sword_Trail.png")
const SWORD_STATS = preload("uid://dyt03vnejfiyb")

const SPEAR_SPRITES = preload("res://Spritesheets/Weapon/Spear_sprites.png")
const SPEAR_TRAIL = preload("res://Spritesheets/Weapon/Spear_Trail.png")
const SPEAR_STATS = preload("uid://bjdl2kn8pe6ek")

const HAMMER_SPRITES = preload("res://Spritesheets/Weapon/Hammer_sprites.png")
const HAMMER_TRAIL = preload("res://Spritesheets/Weapon/Hammer_Trail.png")
const HAMMER_STATS = preload("uid://nclhsmcpabc7")


var weapon_setup_data = {
	0: {
		"stats": SWORD_STATS as MeleeWeaponResource,
		"texture": SWORD_SPRITES,
		"trail_texture": SWORD_TRAIL,
		"offset": Vector2(10, 0),  # Offset applied to both sprite and hitbox
	},
	1: {
		"stats": HAMMER_STATS as MeleeWeaponResource,
		"texture": HAMMER_SPRITES,
		"trail_texture": HAMMER_TRAIL,
		"offset": Vector2(10, 0),
	},
	2: {
		"stats": SPEAR_STATS as MeleeWeaponResource,
		"texture": SPEAR_SPRITES,
		"trail_texture": SPEAR_TRAIL,
		"offset": Vector2(15, 0),
	}
}

@export_category("Weapons")
@export var current_weapon_index : int
@export var weapon_sprite : Sprite2D
@export var hitbox : CollisionPolygon2D
@export var trail : Sprite2D
@export var melee_resource : Resource
@export var animation_tree : AnimationTree
@onready var player: CharacterBody2D = $".."
@onready var cooldown_timer: Timer = $"../State Machine/Attack/CooldownTimer"
@onready var combo_timer: Timer = $"../State Machine/AttackCombo/ComboTimer"

func _ready() -> void:
	_on_weapon_change(current_weapon_index)

#0 -> SWORD, 1 -> Hammer, 2 -> Spear
func _on_weapon_change(weapon_index : int):
	if weapon_index in weapon_setup_data:
		var data = weapon_setup_data[weapon_index]
		current_weapon_index = weapon_index
		melee_resource = data["stats"]
		weapon_sprite.texture = data["texture"]
		trail.texture = data["trail_texture"]
		trail.offset = data["offset"]
		hitbox.polygon = data["stats"].collision_polygon
		_update_range(trail)
		_update_attack_speed(animation_tree, cooldown_timer, combo_timer)


func _update_range(target : Sprite2D):
	target.scale = Vector2(melee_resource.range,melee_resource.range)
	
func _update_attack_speed(animation_tree : AnimationTree, attack_cooldown_timer : Timer, combo_timer : Timer):
	var base_duration = animation_tree.get_animation("DownAttack").length
	var attack_cooldown = base_duration/melee_resource.attack_speed * (1.2)
	animation_tree.set("parameters/Attack/TimeScale/scale", melee_resource.attack_speed)
	animation_tree.set("parameters/Combo/TimeScale/scale", melee_resource.attack_speed)
	attack_cooldown_timer.wait_time = attack_cooldown
	combo_timer.wait_time = attack_cooldown_timer.wait_time * 1.5
