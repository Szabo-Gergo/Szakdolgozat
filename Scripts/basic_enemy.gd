extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _physics_process(delta: float) -> void:
	pass

func _on_hurtbox_entered(area: Area2D) -> void:
	animation_player.play("GotHit")
	
