extends CharacterBody2D
class_name Base_Enemy

@export_category("Enemy Stats")
@export var base_stats : BaseStats
@onready var player: CharacterBody2D = get_node("/root/Main/Player")

var attach_break = 0
