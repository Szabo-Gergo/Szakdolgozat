extends State
class_name Basic_Enemy_Damaged

@export var root: CharacterBody2D
@export var health_component : Health_Component

var state_origin : String
var damaged_again : bool
var dead : bool

func enter(_inputs : Dictionary = {}):
	if _inputs["state_origin"] != self.name:
		state_origin = _inputs["state_origin"] 	
	
	health_component.deal_damage(_inputs["damage"])
	damaged_again = true


func handle_transition():
	if state_origin == "Move":
		transition.emit(self, state_origin)
	else:
		var direction = root.global_position.direction_to(Vector2i(root.player.position))
		transition.emit(self, state_origin, {"direction" : direction})
