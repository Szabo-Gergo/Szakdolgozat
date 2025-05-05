extends Node2D
class_name RootEffectComponent

@export var duration : float = 3
var reset_speed : int
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var target : CharacterBody2D

func _ready() -> void:
	target = get_parent()
	var sprite_bottom = target.sprite.texture.get_height() * 0.3
	print(sprite_bottom)
	global_position = target.global_position + Vector2(0, sprite_bottom)
	reset_speed = target.base_stats.speed
	target.base_stats.speed = 0
	animated_sprite_2d.play("default", 2)
	
func _process(delta: float) -> void:
	duration -= delta
	if duration <= 0: 
		target.base_stats.speed = reset_speed
		animated_sprite_2d.play("default", -2)
		await $AnimatedSprite2D.animation_finished
		queue_free()

	
