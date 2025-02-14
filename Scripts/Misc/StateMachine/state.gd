extends Node
class_name State
signal transition


func enter(_inputs : Dictionary = {}):
	pass
	
func exit():
	pass
	
func process(_delta: float):
	pass
	
func physics_process(_delta: float):
	pass 

func request_transition(new_state_name, inputs := {}):
	print("transition: "+new_state_name)
	emit_signal("transition", self, new_state_name, inputs)
