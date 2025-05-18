extends CharacterBody2D
class_name Base_Enemy
signal reposition

@export_category("Enemy Stats")
@export var base_stats : BaseStats
@export var health_component : Health_Component
@export var sprite : Sprite2D
@export var animation_tree : AnimationTree
@export var elite_crown: Sprite2D
@export var hit_box: Area2D
@export var hurt_box: HurtBoxComponent
@export var collision_shape : CollisionShape2D
@export var droped_xp_amount: int
@onready var player: CharacterBody2D = get_node("/root/Main/Player")

var is_on_screen : bool
var is_elite : bool
var attach_break = 0 #(DO LATER) Should be on the Brain dog only


func _on_screen_entered() -> void:
	is_on_screen = true
	sprite.visible = true
	hit_box.monitoring = true
	hurt_box.monitoring = true
	collision_shape.disabled = false

func _on_screen_exited() -> void:
	is_on_screen = false
	sprite.visible = false
	hit_box.monitoring = false
	hurt_box.monitoring = false
	collision_shape.disabled = true
