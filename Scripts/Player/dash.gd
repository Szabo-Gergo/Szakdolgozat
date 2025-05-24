extends State
class_name Dash

# --- Node references ---
@onready var sprite: Sprite2D = %CharacterSprite
@onready var trail: Sprite2D = %Trail
@onready var player: CharacterBody2D = $"../.."

@export var dash_particle: GPUParticles2D
@export var hurt_box: Area2D
@export var hit_box: Area2D
@export var dash_speed: float
@export var dash_duration: float

var dash_timer: Timer
var dash_velocity: Vector2 = Vector2.ZERO
var attack_buffered: bool = false

# --- Constants ---
const CHARACTER_WIDTH = 32
const CHARACTER_HEIGHT = 34

func _ready() -> void:
	dash_timer = get_child(0)
	dash_timer.wait_time = dash_duration

func enter(inputs: Dictionary = {}) -> void:
	# Resource check
	if not dash_particle or not dash_timer or not sprite or not player:
		push_error("Missing required nodes or resources in Dash state.")
		return

	# Consume dash
	player.available_dash -= 1
	player.can_dash = player.available_dash > 0
	player.main_dash_point_container._decrease_point(1)
	%DashPointContainer._decrease_point(1)

	# Shader effect on sprite
	sprite.material.set("shader_parameter/pixel_size", 1)

	# Temporary invulnerability
	hurt_box.set_collision_mask_value(2, false)
	hit_box.set_collision_mask_value(2, false)

	# Velocity and particle
	attack_buffered = false
	dash_velocity = player.input_direction * player.speed * player.direction_multiplier * dash_speed
	dash_timer.start()
	particle_setup()

func physics_process(_delta: float) -> void:
	particle_setup()
	player.velocity = dash_velocity
	player.move_and_slide()

	# Attack buffering window
	if Input.is_action_just_pressed("attack") and dash_timer.time_left <= dash_timer.wait_time / 3:
		attack_buffered = true

func end_dash() -> void:
	sprite.material.set("shader_parameter/pixel_size", 0)

	hurt_box.set_collision_mask_value(2, true)
	hit_box.set_collision_mask_value(2, true)
	trail.visible = true
	dash_particle.emitting = false

	if attack_buffered:
		var next_state =  "attackcombo" if player.can_combo else "attack"
		var mouse_position = (player.global_position - player.get_global_mouse_position()).normalized() * -1
		transition.emit(self, next_state, {"mouse_position": mouse_position})
	else:
		transition.emit(self, "idle")

func particle_setup() -> void:
	if not sprite.texture:
		return

	var frame_number = sprite.frame
	var frame_x = frame_number * CHARACTER_WIDTH

	var atlas_texture := AtlasTexture.new()
	atlas_texture.atlas = sprite.texture
	atlas_texture.region = Rect2(frame_x, 0, CHARACTER_WIDTH, CHARACTER_HEIGHT)

	dash_particle.texture = atlas_texture
	dash_particle.emitting = true
