extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dummy_sprite: Sprite2D = $DummySprite
@onready var flash_timer: Timer = $FlashTimer
		

func _on_hurtbox_entered(area: Area2D) -> void:
	flash()
	animation_player.stop(true)
	animation_player.play("GotSlammed")
	
func flash():
	dummy_sprite.material.set("shader_parameter/flash_opacity", 1)
	flash_timer.start()
	

func _on_flash_timer_timeout() -> void:
	dummy_sprite.material.set("shader_parameter/flash_opacity", 0)
