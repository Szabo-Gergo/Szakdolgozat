extends State
class_name Basic_Enemy_Attack

@export var root: CharacterBody2D
@export var hitbox: Area2D 
@export var health_component : Health_Component
@export var attacking : bool
@export var hit_on_collision : bool
@export var slide_speed : float

var player_direction : Vector2
var hit_shape

func _ready() -> void:
	hit_shape = hitbox.get_child(0)
	

func enter(_inputs : Dictionary = {}):
	player_direction = root.global_position.direction_to(Vector2i(root.player.position))


func physics_process(_delta: float):
	if slide_speed != 0:
		root.velocity = player_direction * root.base_stats.speed*0.35
		root.move_and_slide()

	
func _on_hit_box_area_exited(area: Area2D) -> void:
	if area.is_in_group("Player_HurtBox"):
		attacking = false


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_HurtBox"):
		attacking = true


func _on_attack_finished(anim_name: StringName) -> void:
	if anim_name == "Attack" and attacking and !hit_on_collision:
		root.player.health_component.deal_damage(root.base_stats.damage)
	transition.emit(self, "Move")
	
func exit():
	attacking = false
