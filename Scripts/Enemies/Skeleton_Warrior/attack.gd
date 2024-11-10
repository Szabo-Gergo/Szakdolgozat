extends State
class_name Basic_Enemy_Attack

@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var skeleton: CharacterBody2D = $"../.."
@onready var hitbox: Area2D = $"../../HitBox"
@export var slide_speed : float

var attacking : bool
var player_direction : Vector2
var stats : BaseStats
var hit_shape

func _ready() -> void:
	hit_shape = hitbox.get_child(0)
	stats = skeleton.get("base_stats")


func enter(_inputs : Dictionary = {}):
	attacking = true
	player_direction = skeleton.global_position.direction_to(Vector2i(player.position))


func physics_process(_delta: float):
	skeleton.velocity = player_direction * slide_speed
	skeleton.move_and_slide()

	
func _on_hit_box_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player_HurtBox"):
		attacking = false


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_HurtBox"):
		attacking = true


func _on_attack_finished(anim_name: StringName) -> void:
	if anim_name == "Attack" and attacking:
		player._add_health(-stats._get_damage())
		print("Player health: "+str(player.health))
	transition.emit(self, "Move")


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_Melee_HitBox"):
		transition.emit(self, "Damaged", {"state_origin" : "Attack", "damage" : player.base_stats._get_damage()})
	elif area.is_in_group("Player_Projectile_HitBox"):
		transition.emit(self, "Damaged", {"state_origin" : "Attack", "damage" : player.projectile_damage})
