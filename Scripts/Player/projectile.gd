extends Area2D

@export var projectile_speed : int
@export var projectile_range : int
@export var animated_sprite : AnimatedSprite2D

var traveled_distance : float = 0

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * projectile_speed * delta
	animated_sprite.play()
	
	traveled_distance += projectile_speed * delta
	if traveled_distance >= projectile_range:
		queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy_HurtBox"):
		queue_free()
