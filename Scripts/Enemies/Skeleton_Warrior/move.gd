extends State
class_name Basic_Enemy_Move

@export var root: Base_Enemy
@export var hitbox: Area2D
@export var sprite: Sprite2D
@export var health_component : Health_Component

@export var separation_radius := 40.0
@export var separation_strength := 100.0  # tweak this to control how much they push away

var direction : Vector2
var frame_count = 0

func enter(_inputs: Dictionary = {}):
	if hitbox:
		hitbox.get_child(0).disabled = false

func process(_delta: float):
	if frame_count % 5 == 0:
		update_hitbox()
	frame_count += 1

func physics_process(delta: float):
	update_movement(delta)
	flip_sprite(sprite, direction)

func flip_sprite(sprite: Sprite2D, direction: Vector2):
	sprite.scale.x = -1 if direction.x > 0 else 1

func update_hitbox():
	hitbox.look_at(root.player.global_position)

func update_movement(delta: float):
	# Direction toward player
	var to_player = (root.player.global_position - root.global_position).normalized()
	direction = to_player.normalized()
	root.velocity = direction * root.get("base_stats").speed
	root.move_and_slide()

func _on_hit_box_area_entered(area: Area2D) -> void:
	if area.is_in_group("Player_HurtBox"):
		transition.emit(self, "Attack")
