extends CharacterBody2D
class_name Base_Enemy

@export_category("Enemy Stats")
@export var base_stats : BaseStats
@export var health_component : Health_Component
@export var sprite : Sprite2D
@export var animation_tree : AnimationTree
@export var elite_crown: Sprite2D
@onready var player: CharacterBody2D = get_node("/root/Main/Player")
 
var attach_break = 0 #(DO LATER) Should be on the Brain dog only

func apply_modifier(elite_type, modifiers):
	elite_crown.visible = true
	var healing_area_node
	
	if elite_type == EliteModifiers.ELITE_TYPES.HEALER:
		healing_area_node = preload("res://Scenes/Misc/healing_area.tscn").instantiate()
		add_child(healing_area_node)
		
	for stat in modifiers:
		match stat:
			"damage_multiplier":
				base_stats.damage *= modifiers[stat]
			"speed_multiplier":
				base_stats.speed *= modifiers[stat]
			"health_multiplier":
				base_stats.max_health *= modifiers[stat]
				health_component.health = base_stats.max_health
			"regen_rate":
				healing_area_node.rate = modifiers[stat]
			"regen_range":
				healing_area_node.range = modifiers[stat]
			"regen_amount":
				healing_area_node.amount = modifiers[stat]
			"size_multiplier":
				sprite.scale *= modifiers[stat] 
			"color":
				sprite.modulate = modifiers[stat]
			"attack_speed_multiplier":
				animation_tree.set("parameters/Attack/TimeScale/scale", modifiers[stat])
