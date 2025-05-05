extends Node2D
class_name ShootComponent

@export var is_aoe : bool
@export_enum("Enemy_HurtBox", "Player_HurtBox") var target_group : String

@export_category("Projectile")
@export var projectile_resource : ProjectileStatResource


const PROJECTILE = preload("res://Projectiles/BaseProjectile.tscn")
var spawn_position : Vector2
var base_rotation

func shoot_projectile(spawn_position : Vector2, base_rotation):
		var num_projectiles = floor(projectile_resource.multishot) 
		self.spawn_position = spawn_position
		self.base_rotation = base_rotation
		
		if randf() < (projectile_resource.multishot - num_projectiles):
			num_projectiles += 1  
	
		if is_aoe:
			fire_with_cone(num_projectiles)
		else:
			fire_with_delay(num_projectiles)
			
func fire_with_cone(num_projectiles : int):
	var rotation_step  : int = 20
	var full_circle : bool = false

	if num_projectiles > 19:
		rotation_step = 360/num_projectiles
		full_circle = true
		
	for i in range(0, num_projectiles):
		var bullet = PROJECTILE.instantiate()
		var rotation_offset
		bullet.global_position = spawn_position
		bullet.target_group = target_group
				
		if full_circle:
			rotation_offset = deg_to_rad(i * rotation_step)
		else:
			if i == 0:
				rotation_offset = 0.0 # First bullet straight
			else:
				var spread_level = ceil(i / 2.0)
				var spread_direction = 1 if i % 2 == 1 else -1
				rotation_offset = deg_to_rad(spread_level * rotation_step  * spread_direction)
			
		bullet.rotation = base_rotation + rotation_offset
		get_parent().add_child(bullet)
		bullet.stats_resource = projectile_resource.duplicate(true)
		bullet._set_base_values()

func fire_with_delay(num_projectiles : int):
	for i in range(num_projectiles):
		var bullet = PROJECTILE.instantiate()
		bullet.global_position = spawn_position
		bullet.target_group = target_group
		var spread_angle = randf_range(-projectile_resource.bullet_spread, projectile_resource.bullet_spread)
		bullet.rotation +=  base_rotation + deg_to_rad(spread_angle)
		
		get_parent().add_child(bullet)
		bullet.stats_resource = projectile_resource.duplicate(true)
		bullet._set_base_values()
		
		await get_tree().create_timer(0.1).timeout
