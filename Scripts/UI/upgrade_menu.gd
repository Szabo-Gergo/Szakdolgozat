extends Control
signal melee_weapon_change(weapon_index : int)
signal ranged_weapon_change(weapon_index : int)
signal player_outfit_change(outfit_index : int)


@onready var skill_trees: SkillTreeHandler = $"MarginContainer/TabContainer/Melee Weapons/HBoxContainer/SkillTrees"
@onready var melee_texture_button: TextureButton = $"MarginContainer/TabContainer/Melee Weapons/HBoxContainer/PanelContainer/WeaponPickerContainer/MeleeTextureButton"
@onready var ranged_texture_button: TextureButton = $"MarginContainer/TabContainer/Secondary Weapons/HBoxContainer/PanelContainer/WeaponPickerContainer/RangedTextureButton"
@onready var outfit_texture_button: TextureButton = $MarginContainer/TabContainer/Outfits/HBoxContainer/PickerContainer/OutfitPickerContainer/OutfitTextureButton



@export var player : CharacterBody2D

var current_melee_index : int = 1
const HAMMER_TEXTURE = preload("res://Spritesheets/Weapon/UI_hammer_texture_atlas.tres")
const SPEAR_TEXTURE = preload("res://Spritesheets/Weapon/UI_spear_texture_atlas.tres")
const SWORD_TEXTURE = preload("res://Spritesheets/Weapon/UI_sword_texture_atlas.tres")
const MELEE_WEAPONS : Dictionary = { "0" = SWORD_TEXTURE, "1" = HAMMER_TEXTURE, "2" = SPEAR_TEXTURE}

var current_ranged_index : int = 1
const PISTOL_TEXTURE = preload("res://Spritesheets/Weapon/Pistol_Sprite.png")
const SHOTGUN_TEXTURE = preload("res://Spritesheets/Weapon/Shotgun_Sprite.png")
const FLAME_THROWER_SPRITE = preload("res://Spritesheets/Weapon/FlameThrower_Sprite.png")
const ROCKET_TEXTURE = preload("res://Spritesheets/Weapon/Rocket_Sprite.png")
const RANGED_WEAPONS : Dictionary = { "0" = PISTOL_TEXTURE, "1" = SHOTGUN_TEXTURE, "2" = FLAME_THROWER_SPRITE, "3" = ROCKET_TEXTURE}

var current_outfit_index : int = 0
const UI_BASE_OUTFIT_ATLAS = preload("res://Spritesheets/Player/UI_base_outfit_atlas.tres")
const UI_BLUE_OUTFIT_ATLAS = preload("res://Spritesheets/Player/UI_blue_outfit_atlas.tres")
const UI_GREEN_OUTFIT_ATLAS = preload("res://Spritesheets/Player/UI_green_outfit_atlas.tres")
const UI_PURPLE_OUTFIT_ATLAS = preload("res://Spritesheets/Player/UI_purple_outfit_atlas.tres")
const PLAYER_OUTFIT : Dictionary = { "0" = UI_BASE_OUTFIT_ATLAS, "1" = UI_BLUE_OUTFIT_ATLAS, "2" = UI_GREEN_OUTFIT_ATLAS, "3" = UI_PURPLE_OUTFIT_ATLAS}


var transitioning_weapons : bool = false

func _ready() -> void:
	_melee_upgrades_setup()
	_ranged_weapon_setup()
	_outfit_setup()

func _on_switch_left_pressed(type:String) -> void:
	if !transitioning_weapons:
		change_weapon(-1, false, type)

func _on_switch_right_pressed(type:String) -> void:
	if !transitioning_weapons:
		change_weapon(1, false, type)

#change_direction => 1 if to the right -1 if to the left 
func change_weapon(change_direction : int, is_setup : bool, item_type : String):
	_set_current_item_index(item_type, change_direction)
	
	match item_type:
		"Melee":
			_start_switch_tween(current_melee_index,is_setup,change_direction,melee_texture_button,MELEE_WEAPONS)
		"Ranged":
			_start_switch_tween(current_ranged_index,is_setup,change_direction,ranged_texture_button,RANGED_WEAPONS)
		"Outfit":
			_start_switch_tween(current_outfit_index,is_setup,change_direction,outfit_texture_button,PLAYER_OUTFIT)
			
	_set_player_item(item_type)


func _set_current_item_index(item_type : String, change_direction : int):
	match item_type:
		"Melee":
			current_melee_index = abs(current_melee_index+change_direction)%MELEE_WEAPONS.size()
		"Ranged":
			current_ranged_index = abs(current_ranged_index+change_direction)%RANGED_WEAPONS.size()
		"Outfit":
			current_outfit_index = abs(current_outfit_index+change_direction)%PLAYER_OUTFIT.size()
			
	
func _start_switch_tween(current_index : int, is_setup : bool, change_direction : int, texture_button : TextureButton, ITEM_DICT : Dictionary):
	if !is_setup:
		var reset_pos = texture_button.position.x
		var out_of_site_pos = (reset_pos + texture_button.size.x)*change_direction
		
		transitioning_weapons = true
		var tween = create_tween() 
		tween.tween_property(texture_button, "position:x", out_of_site_pos, 0.15)
		tween.chain().tween_property(texture_button, "position:x", -out_of_site_pos, 0)
		texture_button.texture_normal = ITEM_DICT.get(str(current_index))
		tween.chain().tween_property(texture_button, "position:x", reset_pos, 0.15)
		await tween.finished
		transitioning_weapons = false
	
func _set_player_item(item_type : String):
	match item_type:
		"Melee":
			change_tree(current_melee_index)
			melee_weapon_change.emit(current_melee_index)
		"Ranged":
			ranged_weapon_change.emit(current_ranged_index)
		"Outfit":
			player_outfit_change.emit(current_outfit_index)

func change_tree(weapon_index):
	match weapon_index:
		0:
			%SwordTree.visible = true
			%HammerTree.visible = false
			%SpearTree.visible = false
		1:
			%SwordTree.visible = false
			%HammerTree.visible = true
			%SpearTree.visible = false
		2:
			%SwordTree.visible = false
			%HammerTree.visible = false
			%SpearTree.visible = true


func _melee_upgrades_setup():
	match player.melee_weapon_node.weapon_sprite.texture: 
		SWORD_TEXTURE:
			current_melee_index = 0
		HAMMER_TEXTURE:
			current_melee_index = 1
		SPEAR_TEXTURE:
			current_melee_index = 2
	
	change_tree(current_melee_index)
	melee_weapon_change.emit(current_melee_index)
	
func _ranged_weapon_setup():
	match player.ranged_weapon_node.weapon_sprite.texture:
		PISTOL_TEXTURE:
			current_ranged_index = 0
		SHOTGUN_TEXTURE:
			current_ranged_index = 1
		FLAME_THROWER_SPRITE:
			current_ranged_index = 2
		ROCKET_TEXTURE:
			current_ranged_index = 3
	
#	HERE UPDATE THE UPGRADE!! (UI SHOULD SHOW THE BASE STATS)
	ranged_weapon_change.emit(current_ranged_index)


func _outfit_setup():
	pass
	
	
