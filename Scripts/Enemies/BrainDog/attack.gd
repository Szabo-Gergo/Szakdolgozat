extends Basic_Enemy_Attack
	
func _on_attack_finished(anim_name: StringName) -> void:
	if anim_name == "Attack" and attacking:
		transition.emit(self, "Attached")
	else:
		transition.emit(self,"Move")
