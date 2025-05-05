extends Node2D
class_name Outfit

const BASE_OUTFIT_RESOURCE = preload("res://Resources/Player/base_outfit_resource.tres")
const BLUE_OUTFIT_RESOURCE = preload("res://Resources/Player/blue_outfit_resource.tres")
const GREEN_OUTFIT_RESOURCE = preload("res://Resources/Player/green_outfit_resource.tres")
const PURPLE_OUTFIT_RESOURCE = preload("res://Resources/Player/purple_outfit_resource.tres")

@export var health_component: Health_Component
@export var outfit_resource : OutfitResource
@onready var character_sprite: Sprite2D = %CharacterSprite
@onready var player: CharacterBody2D = $".."

func _ready() -> void:
	_on_outfit_change(player.base_stats.outfit_type)

func _on_outfit_change(outfit_index : int):
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
	
	health_component.stat_sheet = outfit_resource as BaseStats
	
