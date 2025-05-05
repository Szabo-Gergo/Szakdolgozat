extends State
class_name Basic_Enemy_Move
	
@export var root: CharacterBody2D
@export var hitbox: Area2D
@export var sprite: Sprite2D
@export var health_component : Health_Component

var direction : Vector2
var correcting_signal : bool

	
func enter(_inputs : Dictionary = {}):
	if hitbox:
		hitbox.get_child(0).disabled = false

var frame_count = 0

func process(_delta: float):
	if frame_count % 5 == 0:  
		update_hitbox()

		
func physics_process(_delta: float):
	update_movement()
	flip_sprite(sprite, direction)
	
	
func flip_sprite(sprite : Sprite2D, direction : Vector2):
	if direction.x < 0:
		sprite.scale.x = 1
	else:
		sprite.scale.x = -1
	
	
func update_hitbox():
	hitbox.look_at(root.player.global_position)

	
func update_movement():
	direction = root.global_position.direction_to(Vector2i(root.player.position))
	root.velocity = direction * root.get("base_stats").speed
	root.move_and_slide()	


func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_HurtBox"):
		transition.emit(self, "Attack")
