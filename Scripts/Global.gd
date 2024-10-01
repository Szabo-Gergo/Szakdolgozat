extends Node

var max_dash = 5
var available_dash = max_dash


func _physics_process(delta: float) -> void:
	if (available_dash < max_dash):
		available_dash += 0.7 * delta
