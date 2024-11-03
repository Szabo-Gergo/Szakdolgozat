extends State

@onready var skeleton: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var hitbox: Area2D = $"../../HitBox"
@onready var hit_shape: CollisionPolygon2D = $"../../HitBox/Hit_shape"

@onready var skeleton_sprite: Sprite2D = $"../../Skeleton_Sprite"

var direction : Vector2

func enter(_inputs : Dictionary = {}):
	hit_shape.disabled = false
	
func exit():
	pass
	
func process(_delta: float):
	pass
	
func physics_process(_delta: float):
	direction = skeleton.global_position.direction_to(Vector2i(player.position))
	var velocity = direction * skeleton.get("speed")
	skeleton.velocity = velocity
	skeleton.move_and_slide()
	
#	Flip sprite based on player direction
	if direction.x < 0:
		skeleton_sprite.flip_h = false
	else:
		skeleton_sprite.flip_h = true
	
	update_hurtbox()
	
func update_hurtbox():
	hitbox.look_at(player.global_position)

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.name == "Hitbox":
		transition.emit(self,"Damaged", {"direction" : direction*-1})

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.name == "HurtBox":
		transition.emit(self,"Attack", {"direction" : direction})
