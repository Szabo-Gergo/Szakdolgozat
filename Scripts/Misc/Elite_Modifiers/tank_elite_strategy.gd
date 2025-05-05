extends BaseEliteStrategy
class_name TankEliteStrategy

func apply_modifier(target : Base_Enemy):
	target.base_stats.max_armor *= 1.5
	target.health_component.armor = target.base_stats.max_armor
	target.base_stats.max_health *= 2
	target.health_component.health = target.base_stats.max_health
	target.sprite.modulate = "b87937"
	target.is_elite = true
