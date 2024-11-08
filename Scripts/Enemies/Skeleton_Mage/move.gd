extends Basic_Enemy_Move

@onready var wand_charge_particle: GPUParticles2D = $"../../Wand_Charge_Particle"

func update_hitbox():
	var distance_to_player = skeleton.global_position.distance_to(player.global_position)
	if distance_to_player < skeleton.range:
		hitbox.global_position = player.global_position

func flip_sprite():
	if direction.x < 0:
		skeleton_sprite.flip_h = false
	else:
		skeleton_sprite.flip_h = true
		wand_charge_particle.position *= -1
	
	
