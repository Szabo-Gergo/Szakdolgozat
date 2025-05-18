extends Area2D
class_name ExplosionComponent

@export var range: int
@export var explosion_effect_scene: PackedScene
@export var damage: int = 10
@onready var explosion_shape: CollisionShape2D = $ExplosionShape

var enemies_in_range: Array[CharacterBody2D] = []

func _ready() -> void:
	explosion_shape.shape.radius = range

func explode():
	var explosion_effect = explosion_effect_scene.instantiate()
	explosion_effect.global_position = global_position
	explosion_effect.range = range
	explosion_shape.shape.radius = lerpf(0,range,1)
	get_tree().current_scene.add_child(explosion_effect)
	explosion_effect.particles.connect("finished", func(): queue_free())
	
	
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):	
		body.health_component.deal_damage(damage)
