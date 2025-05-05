extends BaseProjectile
class_name StatusCloudProjectile

@onready var gpu_particles_2d: GPUParticles2D = $GPUParticles2D
@export var status_effect: StatusEffects


func _on_damage_area_entered(area: Area2D) -> void:
	status_effect.apply_effect(area.get_parent(), stats_resource.damage)
