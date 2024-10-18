extends Node

var states : Dictionary = {}
var current_state : State

@export var base_state : State
@onready var state_label = $"../StateLabel"

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
	
	if state != current_state:
		return
		
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
		
	current_state.exit()
	new_state.enter(inputs)
	
	current_state = new_state
	state_label.text = "State: "+current_state.get_name()+"\nAmmo: "+str(Global.ammo)
	
