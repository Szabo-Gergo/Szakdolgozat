extends Node2D

@export var xp_amount : int = 120
@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var sprite: Sprite2D = $Sprite2D

var speed: float = 50
var entered_range: bool = false

func _ready() -> void:
	if xp_amount <= 20:
		sprite.texture = preload("res://Spritesheets/EXP_Sprites/green_xp.png")
	elif xp_amount > 20 and xp_amount <= 40:
		sprite.texture = preload("res://Spritesheets/EXP_Sprites/blue_xp.png")
	elif xp_amount > 40 and xp_amount <= 80:
		sprite.texture = preload("res://Spritesheets/EXP_Sprites/purple_xp.png")
	elif xp_amount > 80:
		sprite.texture = preload("res://Spritesheets/EXP_Sprites/red_xp.png")
		sprite.scale *= xp_amount/80
		
func _physics_process(delta: float) -> void:
	if entered_range:
		var direction = (player.global_position - global_position).normalized()
		position += direction * (player.base_stats.speed+25) * delta
		
func _on_pickup_range_entered(area: Area2D) -> void:
	if area.is_in_group("Player_Pickup_Area"):
		entered_range = true

func _on_player_reached(body: Node2D) -> void:
	if body.name == "Player":
		body.xp_gained(xp_amount)
		queue_free()
