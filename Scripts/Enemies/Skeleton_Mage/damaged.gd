extends Basic_Enemy_Damaged


func handle_transition():
	if health_component.armor + health_component.health <= 0:
		transition.emit(self, "Death")
	else:
		transition.emit(self, "Flee")
