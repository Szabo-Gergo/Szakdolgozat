extends State
class_name Shoot


const PISTOL_PROJECTILE = preload("res://Scenes/PistolProjectile.tscn")

@onready var aim_hand: Node2D = %AimHand
@onready var animation_tree: AnimationTree = %AnimationTree
@onready var camera_2d: Camera2D = $"../../Camera2D"
@onready var bullet_spawn_point: Node2D = %BulletSpawnPoint

var mouse_position
var camera_original_position

func enter(inputs : Dictionary = {}):
	aim_hand.visible = true
	camera_original_position = camera_2d.position 
	
func physics_process(_delta: float):
	print(bullet_spawn_point)
	mouse_position = (aim_hand.global_position - aim_hand.get_global_mouse_position()).normalized()*-1
	animation_tree.set("parameters/idle/blend_position", mouse_position)
	
	if Input.is_action_pressed("shoot"):
		aim_hand.look_at(aim_hand.get_global_mouse_position())
	
	single_shot()
	#print(abs(rad_to_deg(aim_hand.rotation))/360)
	
#Check back later when there are different types of weapons
func camera_knockback():
	camera_2d.position += mouse_position*-25
	await get_tree().create_timer(0.025).timeout
	camera_2d.position = camera_original_position


func single_shot():
	if Input.is_action_just_released("shoot"):
		if Global.ammo != 0:
			var bullet = PISTOL_PROJECTILE.instantiate()
			get_parent().add_child(bullet)
			Global.ammo -= 1
			
			bullet.position = bullet_spawn_point.global_position
			bullet.rotation = bullet_spawn_point.global_rotation
			
			camera_knockback()
			
		aim_hand.visible = false
		transition.emit(self, "move")
