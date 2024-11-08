extends State
class_name Basic_Enemy_Move

	
@onready var skeleton: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var hitbox: Area2D = $"../../HitBox"

@onready var skeleton_sprite: Sprite2D = $"../../Skeleton_Sprite"

var speed : float
var direction : Vector2
var hit_shape 

func _ready() -> void:
	var stats = skeleton.get("base_stats")
	speed = stats._get_speed()
	hit_shape = hitbox.get_child(0)

func enter(_inputs : Dictionary = {}):
	hit_shape.disabled = false

	
func physics_process(_delta: float):
	update_movement()
	update_hitbox()
	flip_sprite()
	
	
#	Flip sprite based on player direction
func flip_sprite():
	if direction.x < 0:
		skeleton_sprite.flip_h = false
	else:
		skeleton_sprite.flip_h = true
	
	
func update_hitbox():
	hitbox.look_at(player.global_position)
	
	
func update_movement():
	direction = skeleton.global_position.direction_to(Vector2i(player.position))
	skeleton.velocity = direction * speed
	skeleton.move_and_slide()	


func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_Melee_HitBox"):
		transition.emit(self,"Damaged", {"state_origin" : "Move", "damage" : player.base_stats._get_damage()})
	elif area.is_in_group("Player_Projectile_HitBox"):
		transition.emit(self,"Damaged", {"state_origin" : "Move", "damage" : player.projectile_damage})


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_HurtBox"):
		transition.emit(self, "Attack")
