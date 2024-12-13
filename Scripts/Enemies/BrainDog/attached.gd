extends State

static var monster_stack : Array

@export var root: CharacterBody2D 
@export var move_state : State
@export var sprite : Sprite2D
@export var pop_off_limit : int

var player : CharacterBody2D
var stand_position_y : float
var struggle : int
@onready var label: Label = $"../../Label"


func enter(_inputs : Dictionary = {}):
	
	struggle = 0		
	
	monster_stack.append(root)
	
	root.player.reversed *= -1
	root.player.can_dash = false
	
	if monster_stack.size() == 1:
		stand_position_y = 20
	else:
		stand_position_y = 10+10*monster_stack.size()
	
	for m in monster_stack:
		m.attach_break = 5*monster_stack.size()
	

	
func physics_process(_delta: float):
	root.position = Vector2(root.player.position.x, root.player.position.y-stand_position_y)
	move_state.flip_sprite(sprite, root.player.velocity)
	
	if Input.is_action_just_pressed("dash"):
		root.attach_break -= 1

	#for m in monster_stack:
		#if m.attach_break == 0:
			#pop_monster()
			
	label.text = str(root.attach_break)

	if root.attach_break == 0:
		pop_monster()
		
func pop_monster():
	var monster = monster_stack.pop_at(0)	
	
	root.player.reversed *= -1
	if monster_stack.is_empty():
		root.player.can_dash = true
	
		
	transition.emit(self, "Detach")
