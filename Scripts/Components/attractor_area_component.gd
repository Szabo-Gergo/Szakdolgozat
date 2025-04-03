extends Node2D
class_name ForceAreaComponent

@export var force_range : int = 50
@export var force_strength : float
@export var is_pulling : bool
@export var affect_enemies : bool
@export var affect_projectiles : bool

var bodies_in_range : Array[CharacterBody2D]

func _ready() -> void:
	get_child(0).shape.radius = force_range

func _physics_process(delta: float) -> void:
	for body in bodies_in_range:
		apply_force(body, delta)

func is_valid_target(area) -> bool:
	if affect_enemies and area.is_in_group("Enemy_HurtBox"):
		return true
	if affect_projectiles and area.is_in_group("Projectile"):
		return true
	return false

func apply_force(body: CharacterBody2D, delta: float):
	var direction = (global_position - body.global_position).normalized()
	if not is_pulling:
		direction *= -1
		
	body.velocity = direction * force_strength * _get_force_falloff() * delta
	body.move_and_slide()

func _on_force_area_entered(area: Area2D) -> void:
	if is_valid_target(area):
		if area.get_parent() is CharacterBody2D and area.get_parent() not in bodies_in_range:
			bodies_in_range.append(area.get_parent())

func _on_force_area_exited(area: Area2D) -> void:
		if area.get_parent() in bodies_in_range:
			bodies_in_range.erase(area.get_parent())

func _get_force_falloff():
	var distance = global_position.distance_to(global_position)
	var force_factor = 1.0 - (distance / force_range)
	return clamp(force_factor, 0, 1)
