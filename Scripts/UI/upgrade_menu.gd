extends Control
signal weapon_change(weapon_index : int)

@onready var skill_trees: SkillTreeHandler = $"MarginContainer/TabContainer/Melee Weapons/HBoxContainer/SkillTrees"
@onready var melee_texture_button: TextureButton = $"MarginContainer/TabContainer/Melee Weapons/HBoxContainer/PanelContainer/WeaponPickerContainer/MeleeTextureButton"
@export var player : CharacterBody2D

var current_melee_index : int = 1
const HAMMER_TEXTURE = preload("res://Spritesheets/Weapon/UI_hammer_texture_atlas.tres")
const SPEAR_TEXTURE = preload("res://Spritesheets/Weapon/UI_spear_texture_atlas.tres")
const SWORD_TEXTURE = preload("res://Spritesheets/Weapon/UI_sword_texture_atlas.tres")
const MELEE_WEAPONS : Dictionary = { "0" = SWORD_TEXTURE, "1" = HAMMER_TEXTURE, "2" = SPEAR_TEXTURE}

var transitioning_weapons : bool = false

func _ready() -> void:
	_melee_upgrades_setup()

func _on_melee_switch_left_pressed() -> void:
	if !transitioning_weapons:
		change_weapon(-1, false)
	
func _on_melee_switch_right_pressed() -> void:
	if !transitioning_weapons:
		change_weapon(1, false)

#change_direction => 1 if to the right -1 if to the left 
func change_weapon(change_direction : int, is_setup : bool):
	
	current_melee_index = abs(current_melee_index+change_direction)%MELEE_WEAPONS.size()
	
	if !is_setup:
		var reset_pos = melee_texture_button.position.x
		var out_of_site_pos = (reset_pos + melee_texture_button.size.x)*change_direction
		
		transitioning_weapons = true
		var tween = create_tween() 
		tween.tween_property(melee_texture_button, "position:x", out_of_site_pos, 0.15)
		tween.chain().tween_property(melee_texture_button, "position:x", -out_of_site_pos, 0)
		melee_texture_button.texture_normal = MELEE_WEAPONS.get(str(current_melee_index))
		tween.chain().tween_property(melee_texture_button, "position:x", reset_pos, 0.15)
		await tween.finished
		transitioning_weapons = false
		
	
	change_tree(current_melee_index)
	weapon_change.emit(current_melee_index)
	

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
	
	match player.melee_weapon.weapon_sprite.texture: 
		SWORD_TEXTURE:
			current_melee_index = 0
		HAMMER_TEXTURE:
			current_melee_index = 1
		SPEAR_TEXTURE:
			current_melee_index = 2
	
	change_tree(current_melee_index)
	weapon_change.emit(current_melee_index)
