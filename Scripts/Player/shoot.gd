extends State
class_name Shoot


const PISTOL_PROJECTILE = 	preload("res://Projectiles/PistolProjectile.tscn")

@export var ranged_weapon: Node2D
@export var bullet_spawn_point: Node2D
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var player_camera: Camera2D = %PlayerCamera
@onready var player: CharacterBody2D = $"../.."

var mouse_position
var camera_original_position

func enter(_inputs : Dictionary = {}):
	ranged_weapon.visible = true
	camera_original_position = player_camera.position 
	
func physics_process(_delta: float):
	animation_update()
	
	if Input.is_action_pressed("shoot"):
		ranged_weapon.look_at(ranged_weapon.get_global_mouse_position())
	
	single_shot()
	
#Check back later when there are different types of weapons
func camera_knockback():
	player_camera.position += mouse_position*-25
	await get_tree().create_timer(0.025).timeout
	player_camera.position = camera_original_position


func animation_update():
	mouse_position = (ranged_weapon.global_position - ranged_weapon.get_global_mouse_position()).normalized()*-1
	animation_tree.set("parameters/"+player._get_animation_tree_name()+"/StateMachine/Shoot/blend_position", mouse_position)

func single_shot():
	if Input.is_action_just_released("shoot"):
		if player.ammo != 0:
			var bullet = PISTOL_PROJECTILE.instantiate()
			get_parent().add_child(bullet)
			player.ammo -= 1
			bullet.position = bullet_spawn_point.global_position
			bullet.rotation = bullet_spawn_point.global_rotation
			
			camera_knockback()
			
		transition.emit(self, "idle")

func exit():
	ranged_weapon.visible = false
