extends BaseEliteStrategy
class_name FastEliteStrategy

func apply_modifier(target : Base_Enemy):
	target.base_stats.speed *= 1.75
	target.animation_tree.set("parameters/Attack/TimeScale/scale", 1.75)
	target.sprite.scale *= Vector2(0.7,0.7)
	target.sprite.modulate = "ff4141"
	target.is_elite = true
