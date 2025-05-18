extends Basic_Enemy_Move
class_name Ranged_Enemy_Move

func update_hitbox():
	var distance_to_player = root.global_position.distance_to(root.player.global_position)
	if distance_to_player < root.range:
		hitbox.global_position = root.player.global_position

		
