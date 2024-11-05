extends State

signal player_hit

@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var skeleton: CharacterBody2D = $"../.."

@onready var hitbox: Area2D = $"../../HitBox"
@onready var hit_shape: CollisionPolygon2D = $"../../HitBox/Hit_shape"
@export var slide_speed : float

var attacking : bool
var slide_direction : Vector2
var stats : BaseStats

func enter(_inputs : Dictionary = {}):
	attacking = true
	hitbox.visible = true
	slide_direction = _inputs["direction"]
	stats = skeleton.get("base_stats")

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

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "HurtBox":
		attacking = true

func _on_attack_finished(anim_name: StringName) -> void:
	if anim_name == "Attack" and attacking:
		player.get("base_stats")._add_health(-stats._get_damage())
		print("Player health: "+str(player.get("base_stats")._get_health()))
	transition.emit(self, "Move")

func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "HitBox":
		transition.emit(self,"Damaged", {"state_origin" : "Attack", "damage" : player.base_stats._get_damage()})
	elif area.name == "ProjectileHitBox":
		transition.emit(self,"Damaged", {"state_origin" : "Attack", "damage" : player.projectile_damage})
