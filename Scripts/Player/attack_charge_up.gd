extends State
class_name AttackChargeUp

var charge_time : float

@onready var animation_tree: AnimationTree = %AnimationTree
@onready var character_body: CharacterBody2D = $"../.."
@onready var player: CharacterBody2D = $"../.."
@onready var melee_weapon: MeleeWeapon = %MeleeWeapon
@onready var sword_sprite: Node2D = %Sword
var base_rotation : float

func enter(inputs : Dictionary = {}):
	base_rotation = melee_weapon.rotation
	sword_sprite.position.x += 20
	
func physics_process(_delta: float):
	var mouse_position = (player.get_global_mouse_position() - player.global_position).normalized()
	melee_weapon.rotation = mouse_position.angle()+PI/2
	
	
	if Input.is_action_pressed("attack"):
			charge_time += _delta
	
	if Input.is_action_just_released("attack"):
		player.charge_transition_time = player.TIME_TO_CHARGE
		if charge_time >= 2.7:
			transition.emit(self, "ChargeAttack")
		else:
			transition.emit(self, "Attack")

	animation_tree.set("parameters/"+player._get_animation_tree_name()+"/StateMachine/ChargeUp/BlendSpace2D/blend_position", mouse_position)

func exit():
	melee_weapon.rotation = base_rotation
	sword_sprite.position.x -= 20
