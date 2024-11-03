extends State
class_name Shoot


const PISTOL_PROJECTILE = preload("res://Scenes/Player/PistolProjectile.tscn")

@onready var aim_hand: Node2D = %AimHand
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var bullet_spawn_point: Node2D = %BulletSpawnPoint
@onready var player_camera: Camera2D = %PlayerCamera

var mouse_position
var camera_original_position

func enter(_inputs : Dictionary = {}):
	aim_hand.visible = true
	camera_original_position = player_camera.position 
	
func physics_process(_delta: float):
	animation_update()
	
	if Input.is_action_pressed("shoot"):
		aim_hand.look_at(aim_hand.get_global_mouse_position())
	
	single_shot()
	
#Check back later when there are different types of weapons
func camera_knockback():
	player_camera.position += mouse_position*-25
	await get_tree().create_timer(0.025).timeout
	player_camera.position = camera_original_position

func animation_update():
	mouse_position = (aim_hand.global_position - aim_hand.get_global_mouse_position()).normalized()*-1
	animation_tree.set("parameters/Shoot/blend_position", mouse_position)


func single_shot():
	if Input.is_action_just_released("shoot"):
		if Global.ammo != 0:
			var bullet = PISTOL_PROJECTILE.instantiate()
			get_parent().add_child(bullet)
			Global.ammo -= 1
			
			bullet.position = bullet_spawn_point.global_position
			bullet.rotation = bullet_spawn_point.global_rotation
			
			camera_knockback()
			
		transition.emit(self, "idle")


func exit():
	aim_hand.visible = false
