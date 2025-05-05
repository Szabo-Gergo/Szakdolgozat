extends Node2D
class_name DoomEffectComponent

@export var charge_duration : float = 5
@export var damage : int = 5
@onready var doom_charge: GPUParticles2D = $DoomCharge
@onready var explosion: GPUParticles2D = $Explosion
var health_component : Health_Component

var charge_time : float
var charging : bool = true

func _ready() -> void:
	global_position = get_parent().global_position
	charge_time = charge_duration
	health_component = get_parent().health_component
	
	
func _process(delta: float) -> void:
	charge_time -= delta
	if charge_time <= 0 and charging:
		doom_charge.emitting = false
		doom_charge.visible = false
		explosion.visible = true
		explosion.emitting = true
		health_component.deal_damage(damage)
		charging = false

func _on_explosion_finished() -> void:
	queue_free()
