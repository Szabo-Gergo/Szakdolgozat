extends State
class_name Attack

@export var damage : int = 1
@export var slide_speed : float = 0
@export var charged_attack : bool

@onready var animation_tree = %AnimationTree
@onready var character_body: CharacterBody2D = $"../.."
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

var mouse_position : Vector2
var charge_time : float
var attack_cooldown : float = 0.3

func enter(inputs : Dictionary = {}):
	charge_time = 0
	charged_attack = false
	mouse_position = inputs.get("mouse_position")
	

func physics_process(delta: float) -> void:
		animation_update()
		character_body.velocity = mouse_position*0
		character_body.move_and_slide()			
		
		
		if Input.is_action_pressed("attack"):
			charge_time += delta
			if charge_time >= 0.2:
				animation_tree.set("parameters/conditions/attacking", false)
				animation_tree.set("parameters/conditions/combo", false)	
				animation_tree.set("parameters/conditions/charge_up", true)
						
			if charge_time >= 2.7:
				charged_attack = true
				charge_time = 0
		
		if Input.is_action_just_released("attack"):
			animation_tree.set("parameters/conditions/charge_up", false)
			
			if charged_attack:
				animation_tree.set("parameters/conditions/charged_attack", true)
			elif animation_tree.get("parameters/conditions/attacking"):
				animation_tree.set("parameters/conditions/attacking", false)
				animation_tree.set("parameters/conditions/combo", true)		
			else:
				animation_tree.set("parameters/conditions/attacking", true)
				
			
				
		if Input.is_action_just_pressed("dash") and Global.available_dash >= 1 and character_body.velocity != Vector2.ZERO:
			transition.emit(self, "dash", {"direction" : mouse_position*350})
			
		
			
			
func _on_attack_finished(anim_name: StringName) -> void:
	animation_tree.set("parameters/conditions/stop_attack", true)
	
	if  "ChargeAttack" in anim_name:
		
		animation_tree.set("parameters/conditions/charged_attack", false)
		transition.emit(self, "move") 
		
	if "Attack" in anim_name and !animation_tree.get("parameters/conditions/combo"):
		
		animation_tree.set("parameters/conditions/stop_attack", true)
		animation_tree.set("parameters/conditions/attacking", false)
		transition.emit(self, "move") 
		
	if "Combo" in anim_name and !animation_tree.get("parameters/conditions/charge_up"):
		
		animation_tree.set("parameters/conditions/stop_attack", true)
		animation_tree.set("parameters/conditions/combo", false)
		transition.emit(self, "move", {"attack_cooldown": attack_cooldown}) 
	

func animation_update():
	animation_tree.set("parameters/conditions/stop_attack", false)
	animation_tree.set("parameters/Attack/blend_position", mouse_position)
	animation_tree.set("parameters/Combo/blend_position", mouse_position)
	animation_tree.set("parameters/ChargeAttack/blend_position", mouse_position)
	animation_tree.set("parameters/ChargeUp/blend_position", mouse_position)
