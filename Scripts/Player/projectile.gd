extends Node2D

@export var projectile_stats_resource: ProjectileStatResource
@export var modifiers: Array[BaseStatModifierStrategy]
@export var animated_sprite : AnimatedSprite2D
var hit_enemies : Array[CharacterBody2D]
var traveled_distance
var current_pierce


func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * projectile_stats_resource.speed * delta
	
	traveled_distance += projectile_stats_resource.speed * delta
	if traveled_distance >= projectile_stats_resource.range:
		queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy_HurtBox"):
		var enemy = area.get_parent()
		if enemy in hit_enemies:
			return  
		else:
			hit_enemies.append(enemy)
			
		current_pierce -= 1
		if current_pierce <= 0:
			queue_free()

func apply_upgrade(stat_type : String, value):
	projectile_stats_resource._apply_stat(stat_type, value)
	

func _set_base_values():
	traveled_distance = 0.0
	current_pierce = projectile_stats_resource.piercing
	
