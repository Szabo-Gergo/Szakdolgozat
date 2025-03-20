extends Control


var current_melee_index : int = 1
@onready var melee_texture_button: TextureButton = $"MarginContainer/TabContainer/Melee Weapons/HBoxContainer/PanelContainer/WeaponPickerContainer/MeleeTextureButton"

const HAMMER_TEXTURE = preload("res://Spritesheets/Weapon/UI_hammer_texture_atlas.tres")
const SPEAR_TEXTURE = preload("res://Spritesheets/Weapon/UI_spear_texture_atlas.tres")
const SWORD_TEXTURE = preload("res://Spritesheets/Weapon/UI_sword_texture_atlas.tres")

const MELEE_WEAPONS : Dictionary = { "0" = SWORD_TEXTURE, "1" = HAMMER_TEXTURE, "2" = SPEAR_TEXTURE}

var transitioning_weapons : bool = false


func _on_melee_switch_left_pressed() -> void:
	if !transitioning_weapons:
		change_weapon(-1)
	

func _on_melee_switch_right_pressed() -> void:
	if !transitioning_weapons:
		change_weapon(1)

#change_direction => 1 if to the right -1 if to the left 
func change_weapon(change_direction : int):
	transitioning_weapons = true
	current_melee_index = abs(current_melee_index+change_direction)%MELEE_WEAPONS.size()
	var reset_pos = melee_texture_button.position.x
	
	var out_of_site_pos = (melee_texture_button.position.x + melee_texture_button.size.x)*change_direction
	
	var out_tween = create_tween()
	slide_tween(out_tween, out_of_site_pos)
	await out_tween.finished
	
	melee_texture_button.texture_normal = MELEE_WEAPONS.get(str(current_melee_index))
	melee_texture_button.position.x = out_of_site_pos*-1
	
	var reset_tween = create_tween()
	slide_tween(reset_tween, reset_pos)
	await reset_tween.finished
	transitioning_weapons = false


func slide_tween(tween : Tween , slide_to_positon : float):
	tween.tween_property(
		melee_texture_button, 
		"position:x",  
		slide_to_positon,  
		0.25
	).set_trans(Tween.TRANS_CUBIC)
