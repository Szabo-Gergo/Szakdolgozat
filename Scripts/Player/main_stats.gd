extends Node
@export_category("Base Stats")
@export var base_stats : Resource

@export_category("Side Stats")
@export var max_dash = 100000
@export var max_ammo = 6
@export var projectile_damage = 5

var available_dash = max_dash
var ammo = 6

func _physics_process(delta: float) -> void:
	if (available_dash < max_dash):
		available_dash += 0.7 * delta
