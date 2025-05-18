extends State
class_name Shoot


const PROJECTILE = preload("res://Projectiles/BaseProjectile.tscn")
@onready var ranged_weapon: RangedWeapon = $"../../RangedWeapon"
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var player_camera: Camera2D = %PlayerCamera
@onready var player: CharacterBody2D = $"../.."
@onready var shoot_component: ShootComponent = %ShootComponent

var mouse_position
var projectile_resource: ProjectileStatResource

func enter(_inputs : Dictionary = {}):
	ranged_weapon.visible = true
	player_camera.position = Vector2(0,0) 
	projectile_resource = ranged_weapon._get_projectile_resource()
	shoot_component.projectile_resource = ranged_weapon._get_projectile_resource()
	
func physics_process(_delta: float):
	animation_update()
	if Input.is_action_pressed("shoot"):
		ranged_weapon.look_at(ranged_weapon.get_global_mouse_position())
		if ranged_weapon.projectile_resource.is_flamethrower:
			set_projectile()
		
	if Input.is_action_just_released("shoot"):
		set_projectile()
	

func animation_update():
	mouse_position = (ranged_weapon.global_position - ranged_weapon.get_global_mouse_position()).normalized()*-1
	animation_tree.set("parameters/"+player._get_animation_tree_name()+"/StateMachine/Shoot/blend_position", mouse_position)

func set_projectile():
	if player.ammo > ranged_weapon.projectile_resource.ammo_cost:
		shoot_component.shoot_projectile(ranged_weapon.get_child(0).global_position, ranged_weapon.rotation)
		player.ammo -= projectile_resource.ammo_cost
		if fmod(player.ammo, 1) <= 0.01:
			if projectile_resource.ammo_cost < 1:
				player.main_ammo_point_container._decrease_point(1)
			else:
				player.main_ammo_point_container._decrease_point(projectile_resource.ammo_cost)
		
	transition.emit(self, "idle")


func exit():
	ranged_weapon.visible = false
