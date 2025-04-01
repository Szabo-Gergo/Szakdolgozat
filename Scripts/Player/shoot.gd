extends State
class_name Shoot


const PROJECTILE = preload("res://Projectiles/Projectile.tscn")

@export var ranged_weapon: Node2D
@export var bullet_spawn_point: Node2D
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var player_camera: Camera2D = %PlayerCamera
@onready var player: CharacterBody2D = $"../.."

var mouse_position
var camera_original_position
var projectile_resource: ProjectileStatResource

func enter(_inputs : Dictionary = {}):
	ranged_weapon.visible = true
	camera_original_position = player_camera.position 
	projectile_resource = ranged_weapon._get_projectile_resource()
	
func physics_process(_delta: float):
	animation_update()
	
	if Input.is_action_pressed("shoot"):
		ranged_weapon.look_at(ranged_weapon.get_global_mouse_position())
	
	if Input.is_action_just_released("shoot"):
		set_projectile()
	
func camera_knockback():
	player_camera.position += mouse_position*-25
	await get_tree().create_timer(0.025).timeout
	player_camera.position = camera_original_position

func animation_update():
	mouse_position = (ranged_weapon.global_position - ranged_weapon.get_global_mouse_position()).normalized()*-1
	animation_tree.set("parameters/"+player._get_animation_tree_name()+"/StateMachine/Shoot/blend_position", mouse_position)

func set_projectile():
	if player.ammo > 0:
		var num_projectiles = floor(projectile_resource.multishot) 
	
		if randf() < (projectile_resource.multishot - num_projectiles):
			num_projectiles += 1  
		
		for i in range(num_projectiles):
			spawn_projectile()

		player.ammo -= projectile_resource.ammo_cost
		camera_knockback()

	transition.emit(self, "idle")

func spawn_projectile():
	var bullet = PROJECTILE.instantiate()
	get_parent().add_child(bullet)
	
	bullet.position = bullet_spawn_point.global_position
	
	var spread_angle = randf_range(-projectile_resource.bullet_spread, projectile_resource.bullet_spread)
	bullet.rotation = bullet_spawn_point.global_rotation + deg_to_rad(spread_angle)
	
	bullet.projectile_stats_resource = projectile_resource.duplicate(true)
	bullet._set_base_values()

func exit():
	ranged_weapon.visible = false
