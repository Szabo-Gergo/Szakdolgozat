extends Basic_Enemy_Move
@onready var wand_charge_particle: GPUParticles2D = $"../../Skeleton_Sprite/Wand_Charge_Particle"

var scale : Vector2

func _ready() -> void:
	super()
	scale = skeleton_sprite.scale

func update_hitbox():
	var distance_to_player = skeleton.global_position.distance_to(skeleton.player.global_position)
	if distance_to_player < skeleton.range:
		hitbox.global_position = player.global_position


func flip_sprite():
	super()
	print(str(wand_charge_particle.position))

	if scale != skeleton_sprite.scale:
		wand_charge_particle.position.x *= -1
		scale = skeleton_sprite.scale

	
