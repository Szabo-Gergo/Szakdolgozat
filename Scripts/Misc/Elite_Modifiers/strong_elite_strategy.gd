extends BaseEliteStrategy
class_name StrongEliteStrategy

func apply_modifier(target : Base_Enemy):
	target.base_stats.damage *= 1.5
	target.base_stats.max_armor *= 1.33
	target.health_component.armor = target.base_stats.max_armor
	target.sprite.modulate = "b87937"
	target.is_elite = true
