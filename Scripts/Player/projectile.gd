extends Area2D

@export var projectile_speed : int
@export var projectile_range : int
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var traveled_distance : float = 0

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * projectile_speed * delta
	animated_sprite_2d.play()
	
	traveled_distance += projectile_speed * delta
	if traveled_distance >= projectile_range:
		queue_free()
	
func _on_area_entered(area: Area2D) -> void:
	if area.name == "HurtBox":
		queue_free()
