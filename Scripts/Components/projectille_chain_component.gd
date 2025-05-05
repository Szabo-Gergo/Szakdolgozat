extends Area2D
class_name ProjectileChainComponent

@export var chain_amount : int
var enemies_to_chain : Array[Node2D]

func get_closest_enemy():
	
	enemies_to_chain.sort_custom(self._sort_enemies)
	if !enemies_to_chain.is_empty():
		return enemies_to_chain[0]

func _sort_enemies(a, b) -> bool:
	var dist_a = global_position.distance_to(a.global_position)
	var dist_b = global_position.distance_to(b.global_position)
	
	return dist_a <= dist_b

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemies_to_chain.append(body)
		

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemies_to_chain.erase(body)


func chain(chain_start_body : CharacterBody2D):
	enemies_to_chain.erase(chain_start_body)
	if !enemies_to_chain.is_empty():
		var closest_enemy = get_closest_enemy()
		on_chain_effect()
		enemies_to_chain.erase(closest_enemy)
	
		if chain_amount == 0:
			queue_free()
	

func on_chain_effect():
	get_parent().look_at(get_closest_enemy().global_position)
	chain_amount -= 1
