extends State
class_name Dash

@onready var sprite: Sprite2D = %CharacterSprite
@onready var player: CharacterBody2D = $"../.."
@onready var dash_particle: GPUParticles2D = %DashParticle

@onready var collision: CollisionShape2D = %CollisionShape2D
@onready var hurt_box: CollisionShape2D = $"../../HurtBox/Hurt_shape"
@onready var dash_timer: Timer = $Dash_Timer

const character_width = 32
const character_height = 34

@export var dash_speed : float
@export var dash_duration : float

var max_dash 
var dash_velocity

func _ready() -> void:
	max_dash = player.max_dash
	dash_timer.wait_time = dash_duration


func enter(inputs : Dictionary = {}):
	particle_setup()
	sprite.material.set("shader_parameter/pixel_size", 1)
	
	collision.disabled = true
	hurt_box.disabled = true
	
	var dash_direction = inputs.get("direction")
	dash_velocity = dash_direction * dash_speed
	dash_timer.start()
	
func end_dash():
	player.available_dash -= 1
	sprite.material.set("shader_parameter/pixel_size", 0)
	
	collision.disabled = false
	hurt_box.disabled = false
	dash_particle.emitting = false
	
	transition.emit(self, "idle")
	
func physics_process(_delta: float):
	particle_setup()
	player.velocity = dash_velocity
	player.move_and_slide()


func particle_setup():
	var current_frame = AtlasTexture.new()
	var frame_number = sprite.frame

	var frame_x = frame_number * character_width
	current_frame.region = Rect2(frame_x, 0, character_width, character_height)
	current_frame.atlas = sprite.texture
	
	dash_particle.texture = current_frame
	dash_particle.emitting = true
