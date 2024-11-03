extends State

signal player_hit

@onready var hitbox: Area2D = $"../../HitBox"
@onready var hit_shape: CollisionPolygon2D = $"../../HitBox/Hit_shape"
@onready var skeleton: CharacterBody2D = $"../.."

@export var slide_speed : float

var attacking : bool
var hitbox_gradiant : float
var slide_direction : Vector2

func enter(_inputs : Dictionary = {}):
	attacking = true
	hitbox.visible = true
	hitbox_gradiant = 0
	slide_direction = _inputs["direction"]

func exit():
	hit_shape.disabled = true
	
func process(_delta: float):
	pass
	
func physics_process(_delta: float):
	skeleton.velocity = slide_direction * slide_speed
	skeleton.move_and_slide()
	
func _on_hit_box_area_exited(area: Area2D) -> void:
	if area.name == "HurtBox":
		attacking = false

func _on_attack_finished(anim_name: StringName) -> void:
	if anim_name == "Attack" and attacking:
		player_hit.emit(skeleton.damage)
	
	transition.emit(self, "Move")
	
