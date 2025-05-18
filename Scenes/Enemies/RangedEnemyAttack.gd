extends Basic_Enemy_Attack
class_name RangedEnemyAttack

@export var shoot_component : ShootComponent
@export var projectile_spawnpoint : Node2D
@export var can_predict : bool
@export var predict_offset : float

var travel_time : float
var projectile : ProjectileStatResource
var predicted_position : Vector2 = Vector2(0,0)

func _ready() -> void:
	if shoot_component:
		projectile = shoot_component.projectile_resource
		
func enter(_inputs: Dictionary = {}):
	super.enter(_inputs)
	if can_predict:
		predicted_position = get_predicted_player_position()

	if shoot_component:
		var direction = (predicted_position - root.global_position).normalized()
		shoot_component.shoot_projectile(projectile_spawnpoint.global_position, direction.angle())
	else:
		hitbox.global_position = predicted_position
		
func get_predicted_player_position() -> Vector2:
	var distance = root.global_position.distance_to(root.player.global_position)
	var move_dir = root.player.velocity

	if shoot_component:
		travel_time = distance / shoot_component.projectile_resource.speed
		return root.player.global_position + move_dir * travel_time
	else:
		return root.player.global_position + move_dir * predict_offset
