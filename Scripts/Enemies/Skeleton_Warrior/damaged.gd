extends State
class_name Basic_Enemy_Damaged

@export var animation_tree: AnimationTree
@export var sprite: Sprite2D 
@export var root: CharacterBody2D
@export var damage_number_component : Node2D
@export var health_component : Health_Component

var state_origin : String
var base_damage : int
var damaged_again : bool
var dead : bool

func enter(_inputs : Dictionary = {}):
	if _inputs["state_origin"] != self.name:
		state_origin = _inputs["state_origin"] 	
	base_damage = _inputs["damage"]
	health_component.deal_damage(base_damage)
	damaged_again = true

func handle_transition():
	health_component.check_health()
	
	if state_origin == "Move" or state_origin == "Death":
		transition.emit(self, state_origin)
	else:
		var direction = root.global_position.direction_to(Vector2i(root.player.position))
		transition.emit(self, state_origin, {"direction" : direction})		
