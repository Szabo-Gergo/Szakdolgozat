extends BaseEliteStrategy
class_name HealerEliteStrategy

func apply_modifier(target : Base_Enemy):
	var healing_area_node = preload("res://Scenes/Misc/healing_area.tscn").instantiate()
	healing_area_node.rate = 5
	healing_area_node.range = 10
	healing_area_node.amount = 4
	target.sprite.modulate = "00f64a"
	target.add_child(healing_area_node)
	target.is_elite = true
