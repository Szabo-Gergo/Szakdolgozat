extends CharacterBody2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var dummy_sprite: Sprite2D = $DummySprite
@onready var flash_timer: Timer = $FlashTimer
@onready var player : CharacterBody2D

func _ready() -> void:
	player = get_tree().get_root().find_child("Player", true, false)
