extends State
class_name Dash


@onready var sprite: Sprite2D = %CharacterSprite
@onready var trail: Sprite2D = %Trail

@onready var player: CharacterBody2D = $"../.."
@onready var dash_particle: GPUParticles2D = %DashParticle

@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var hurt_box: CollisionShape2D = $"../../HurtBox/Hurt_shape"
@onready var hit_box: CollisionPolygon2D = $"../../Trail/HitBox/CollisionPolygon2D"
@onready var dash_timer: Timer = $Dash_Timer

const character_width = 32
const character_height = 34

@export var dash_speed : float
@export var dash_duration : float
@export var can_attack_in_dash : bool

var dash_velocity : Vector2
var attack_buffered : bool 

func _ready() -> void:
	dash_timer.wait_time = dash_duration

func enter(inputs : Dictionary = {}):
	particle_setup()
	sprite.material.set("shader_parameter/pixel_size", 1)
	
	collision.disabled = true
	hurt_box.disabled = true
	attack_buffered = false
	
	if can_attack_in_dash: 
		hit_box.disabled = can_attack_in_dash
		trail.visible = false

	if player.speed != player.base_stats.speed:
		player.speed = player.base_stats.speed
		dash_velocity = player.input_direction * player.speed	* player.reversed * dash_speed
	else:
		dash_velocity = player.velocity * dash_speed
	
	dash_velocity = player.input_direction * player.speed	* player.reversed * dash_speed
	dash_timer.start()
	
func end_dash():
	player.available_dash -= 1
	sprite.material.set("shader_parameter/pixel_size", 0)
	
	collision.disabled = false
	hurt_box.disabled = false
	hit_box.disabled = false
	trail.visible = true
	dash_particle.emitting = false
	
	if attack_buffered:
		var new_state = "attackcombo" if player.can_combo else "attack"
		var mouse_position = (player.global_position - player.get_global_mouse_position()).normalized()*-1
		transition.emit(self, new_state, {"mouse_position": mouse_position})
	else:
		transition.emit(self, "idle")
	
func physics_process(_delta: float):
	particle_setup()
	player.velocity = dash_velocity
	player.move_and_slide()
	if Input.is_action_just_pressed("attack") and dash_timer.time_left <= dash_timer.wait_time/3:
		attack_buffered = true


func particle_setup():
	var current_frame = AtlasTexture.new()
	var frame_number = sprite.frame

	var frame_x = frame_number * character_width
	current_frame.region = Rect2(frame_x, 0, character_width, character_height)
	current_frame.atlas = sprite.texture
	
	dash_particle.texture = current_frame
	dash_particle.emitting = true
