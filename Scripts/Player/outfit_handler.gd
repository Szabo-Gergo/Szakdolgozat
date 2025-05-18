extends Node2D
class_name Outfit

const BASE_OUTFIT_RESOURCE = preload("res://Resources/Player/base_outfit_resource.tres")
const BLUE_OUTFIT_RESOURCE = preload("res://Resources/Player/blue_outfit_resource.tres")
const GREEN_OUTFIT_RESOURCE = preload("res://Resources/Player/green_outfit_resource.tres")
const PURPLE_OUTFIT_RESOURCE = preload("res://Resources/Player/purple_outfit_resource.tres")

@export var health_component: Health_Component
@export var outfit_resource : OutfitResource
@onready var character_sprite: Sprite2D = %CharacterSprite
@onready var player: Player = $".."
@onready var melee_weapon: MeleeWeapon = %MeleeWeapon
@onready var ranged_weapon: RangedWeapon = $"../RangedWeapon"

func _ready() -> void:
	_on_outfit_change(player.base_stats.outfit_type)

func _on_outfit_change(outfit_index : int):
	var previous_resource: OutfitResource

	match RuntimeSaves.player_stats.outfit_type:
		0: previous_resource = BASE_OUTFIT_RESOURCE
		1: previous_resource = BLUE_OUTFIT_RESOURCE
		2: previous_resource = GREEN_OUTFIT_RESOURCE
		3: previous_resource = PURPLE_OUTFIT_RESOURCE

	if RuntimeSaves.outfit_initialized:
		previous_resource.melee_upgrades.apply_stat(melee_weapon, true)
		previous_resource.ranged_upgrades.apply_stat(ranged_weapon, true)
		print("\n\nEFFECT REMOVED :" + str(previous_resource.melee_upgrades))

	# Switch outfit
	match outfit_index:
		0:
			outfit_resource = BASE_OUTFIT_RESOURCE
			character_sprite.texture = load("uid://dbn2mklyayrpf")
		1:
			outfit_resource = BLUE_OUTFIT_RESOURCE
			character_sprite.texture = load("uid://bb24k6ts2eg4k")
		2:
			outfit_resource = GREEN_OUTFIT_RESOURCE
			character_sprite.texture = load("uid://xx5u1kybrffs")
		3:
			outfit_resource = PURPLE_OUTFIT_RESOURCE
			character_sprite.texture = load("uid://dk3gnpd0bloso")

	# Apply
	apply_upgrades()
	ranged_weapon.max_ammo = outfit_resource.max_ammo
	RuntimeSaves.outfit_initialized = true
	health_component.stat_sheet = outfit_resource as BaseStats
	RuntimeSaves.player_stats.outfit_type = outfit_index
	RuntimeSaves.save_resources()
	ui_change()
	
func ui_change():
	player.available_dash = outfit_resource.max_dash
	player.ammo = ranged_weapon.max_ammo
	
	%DashPointContainer.max_point = outfit_resource.max_dash
	%DashContainer.max_point = outfit_resource.max_dash
	%AmmoContainer.max_point = ranged_weapon.max_ammo
	
	%DashPointContainer._generate_points()
	%DashContainer._generate_points()
	%AmmoContainer._generate_points()

func apply_upgrades():
	outfit_resource.melee_upgrades.apply_stat(melee_weapon)
	outfit_resource.ranged_upgrades.apply_stat(ranged_weapon)
	print("\n\nEFFECT APPLIED :"+str(outfit_resource))

func remove_upgrades():
	print("\n\nEFFECT REMOVED :"+str(outfit_resource.melee_upgrades))
	outfit_resource.melee_upgrades.apply_stat(melee_weapon, true)
	outfit_resource.ranged_upgrades.apply_stat(ranged_weapon, true)
