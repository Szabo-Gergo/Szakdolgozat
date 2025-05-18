extends Control
signal melee_weapon_change(weapon_index : int)
signal ranged_weapon_change(weapon_index : int)
signal player_outfit_change(outfit_index : int)


@onready var st_handler: SkillTreeHandler = $"MarginContainer/TabContainer/Melee Weapons/HBoxContainer/SkillTrees"
@onready var melee_texture_button: TextureButton = $"MarginContainer/TabContainer/Melee Weapons/HBoxContainer/PanelContainer/WeaponPickerContainer/MeleeTextureButton"
@onready var ranged_texture_button: TextureButton = $"MarginContainer/TabContainer/Secondary Weapons/HBoxContainer/PanelContainer/WeaponPickerContainer/RangedTextureButton"
@onready var outfit_texture_button: TextureButton = $MarginContainer/TabContainer/Outfits/HBoxContainer/PickerContainer/OutfitPickerContainer/OutfitTextureButton



@export var player : Player

var current_melee_index : int = 1
const HAMMER_TEXTURE = preload("res://Spritesheets/Weapon/UI_hammer_texture_atlas.tres")
const SPEAR_TEXTURE = preload("res://Spritesheets/Weapon/UI_spear_texture_atlas.tres")
const SWORD_TEXTURE = preload("res://Spritesheets/Weapon/UI_sword_texture_atlas.tres")
const MELEE_WEAPONS : Array = [SWORD_TEXTURE,HAMMER_TEXTURE,SPEAR_TEXTURE]

var current_ranged_index : int = 1
const PISTOL_TEXTURE = preload("res://Spritesheets/Weapon/Pistol_Sprite.png")
const SHOTGUN_TEXTURE = preload("res://Spritesheets/Weapon/Shotgun_Sprite.png")
const FLAME_THROWER_SPRITE = preload("res://Spritesheets/Weapon/FlameThrower_Sprite.png")
const ROCKET_TEXTURE = preload("res://Spritesheets/Weapon/Rocket_Sprite.png")
const RANGED_WEAPONS : Array = [PISTOL_TEXTURE,SHOTGUN_TEXTURE,FLAME_THROWER_SPRITE,ROCKET_TEXTURE]

var current_outfit_index : int = 0
const UI_BASE_OUTFIT_ATLAS = preload("res://Spritesheets/Player/UI_base_outfit_atlas.tres")
const UI_BLUE_OUTFIT_ATLAS = preload("res://Spritesheets/Player/UI_blue_outfit_atlas.tres")
const UI_GREEN_OUTFIT_ATLAS = preload("res://Spritesheets/Player/UI_green_outfit_atlas.tres")
const UI_PURPLE_OUTFIT_ATLAS = preload("res://Spritesheets/Player/UI_purple_outfit_atlas.tres")
const PLAYER_OUTFIT : Array = [UI_BASE_OUTFIT_ATLAS, UI_BLUE_OUTFIT_ATLAS, UI_GREEN_OUTFIT_ATLAS, UI_PURPLE_OUTFIT_ATLAS]


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
			
func _start_switch_tween(current_index : int, is_setup : bool, change_direction : int, texture_button : TextureButton, ITEM_ARR : Array):
	if !is_setup:
		var reset_pos = texture_button.position.x
		var out_of_site_pos = (reset_pos + texture_button.size.x)*change_direction
		
		transitioning_weapons = true
		var tween = create_tween() 
		tween.tween_property(texture_button, "position:x", out_of_site_pos, 0.15)
		tween.chain().tween_property(texture_button, "position:x", -out_of_site_pos, 0)
		texture_button.texture_normal = ITEM_ARR[current_index]
		tween.chain().tween_property(texture_button, "position:x", reset_pos, 0.15)
		await tween.finished
		transitioning_weapons = false
	
func _set_player_item(item_type : String):
	match item_type:
		"Melee":
			change_tree()
			melee_weapon_change.emit(current_melee_index)
		"Ranged":
			ranged_weapon_change.emit(current_ranged_index)
			_change_ranged_labels()
		"Outfit":
			player_outfit_change.emit(current_outfit_index)
			_change_outfit_labels()
			
func change_tree():
	match current_melee_index:
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
	melee_texture_button.texture_normal = MELEE_WEAPONS[current_melee_index]
	current_melee_index = player.base_stats.melee_weapon_type
	change_tree()

func _ranged_weapon_setup():
	
	ranged_texture_button.texture_normal = RANGED_WEAPONS[current_ranged_index]
	current_ranged_index = player.base_stats.ranged_weapon_type
	_change_ranged_labels()

func _outfit_setup():
	outfit_texture_button.texture_normal = PLAYER_OUTFIT[current_outfit_index]
	current_outfit_index = player.base_stats.outfit_type
	_change_outfit_labels()

func _change_outfit_labels():
	var current_resource = player.outfit_node.outfit_resource
	var resource_text = current_resource.get_outfit_string()
	%TitleLabel.text = resource_text.get("name")
	%StatsLabel.text = resource_text.get("base_stats")
	%MeleeBuffLabel.text = resource_text.get("melee_upgrades")
	%RangedBuffLabel.text = resource_text.get("ranged_upgrades")

func _change_ranged_labels():

	var current_resource = player.ranged_weapon_node.projectile_resource
	var resource_text = current_resource.get_weapon_string()

	%SecondaryTitleLabel.text = resource_text["name"]
	%ProjectileBuffLabel.text = resource_text["base_stats"]
	%EffectLabel.text = resource_text["effects"]
