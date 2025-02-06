extends Node
class_name StateMachine

var states : Dictionary = {}
var current_state : State
@export var base_state : State
@onready var label: Label = $"../Label"
@onready var player: CharacterBody2D = $".."
func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
		
	if base_state:
		base_state.enter()
		current_state = base_state
		
	
func _process(delta: float) -> void:
	if current_state:
		current_state.process(delta)
		
func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_process(delta)
		

func on_state_transition(state, new_state_name, inputs : Dictionary = {}):
	current_state.exit()
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	new_state.enter(inputs)
	current_state = new_state
	label.text = current_state.name
	print(current_state.name)
