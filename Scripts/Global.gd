extends Node

var max_dash = 5
var available_dash = max_dash

var ammo = 6
var max_ammo = 6

func _physics_process(delta: float) -> void:
	if (available_dash < max_dash):
		available_dash += 0.7 * delta
