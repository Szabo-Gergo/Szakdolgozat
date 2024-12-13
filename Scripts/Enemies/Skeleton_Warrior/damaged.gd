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

func enter(_inputs : Dictionary = {}):
	if _inputs["state_origin"] != self.name:
		state_origin = _inputs["state_origin"] 	
	base_damage = _inputs["damage"]
	health_component.deal_damage(base_damage)
	damaged_again = true

func _on_damaged_finished(anim_name: StringName) -> void:
	if anim_name == "Damaged":
		damaged_again = false
		handle_transition()


func handle_transition():
	if health_component.armor + health_component.health <= 0:
		transition.emit(self, "Death")
	
	if state_origin == "Move":
		transition.emit(self, state_origin)
	else:
		var direction = root.global_position.direction_to(Vector2i(root.player.position))
		transition.emit(self, state_origin, {"direction" : direction})		
