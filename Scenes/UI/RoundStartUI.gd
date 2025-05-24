extends Control

@onready var challange_container: VBoxContainer = %ChallangeContainer
const CHALLANGE_SETTER = preload("res://Scenes/Misc/challange_setter.tscn")
@export var upgrade_material_gain_buff : float = 1
var spawner_modifier

func _ready() -> void:
	spawner_modifier = RuntimeSaves.spawner_modifiers
	
func _on_teleport_pressed() -> void:
	get_tree().paused = false
	
	for setter in challange_container.get_children():
		var setter_effect = setter.challange_effect
		for challange_effect in spawner_modifier.challange_effects:
			if setter_effect.effect_type == challange_effect.effect_type:
				challange_effect.value = setter_effect.value
	
	get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	

func _on_update_buff_label(value) -> void:
	spawner_modifier.upgrade_material_boost += value
	
	%MaterialBuffLabel.text = "+"+str(spawner_modifier.upgrade_material_boost*100)+"% Material gain"
