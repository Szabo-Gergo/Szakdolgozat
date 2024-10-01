extends State
class_name Dash

@onready var character_body = $"../.."
@onready var character_sprite = %Sprite2D

@onready var dash_timer = $DurationTimer
@onready var dash_particle: GPUParticles2D = %DashParticle

@onready var character_collision: CollisionShape2D = %CollisionShape2D

@export var max_dash = Global.max_dash
@export var dash_speed = 3.0
@export var dash_duration = 0.15

var dash_velocity

func enter(inputs : Dictionary = {}):
	particle_setup()
	character_collision.disabled = true
	var dash_direction = inputs.get("direction")
	dash_velocity = dash_direction * dash_speed
	dash_timer.wait_time = dash_duration
	dash_timer.start()
	
func end_dash():
	Global.available_dash -= 1
	character_collision.disabled = false
	dash_particle.emitting = false
	transition.emit(self, "move")
	
func physics_process(_delta: float):
	particle_setup()
	character_body.velocity = dash_velocity
	character_body.move_and_slide()


func particle_setup():
	var current_frame = AtlasTexture.new()
	var character_width = 32
	var character_height = 34
	var frame_number = character_sprite.frame

	var frame_x = frame_number * character_width
	current_frame.region = Rect2(frame_x, 0, character_width, character_height)
	current_frame.atlas = character_sprite.texture
	
	dash_particle.texture = current_frame
	dash_particle.emitting = true
