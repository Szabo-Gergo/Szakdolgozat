extends Node2D

@onready var particles = $GPUParticles2D

@export var color_ramp: GradientTexture1D
@export var speed: float = 200.0
@export var range: float = 100.0

func _ready():
	particles.local_coords = false
	var particle_material = particles.process_material as ParticleProcessMaterial
	
	particle_material.initial_velocity_min = speed
	particle_material.initial_velocity_max = speed
	particle_material.color_ramp = color_ramp
	particles.lifetime = range / speed
	particles.emitting = true
	
