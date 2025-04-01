extends CharacterBody2D
signal level_up

@onready var state_machine: StateMachine = $"State Machine"
@onready var animation_tree = %AnimationTree

@export_category("Stats")
@export var base_stats : BaseStats

@export var max_dash : int 
@export var max_ammo : int 
@export var projectile_damage : int

@export var health_component : Health_Component
@export var melee_weapon : MeleeWeapon
@export var ranged_weapon : RangedWeapon

@export_enum("Sword","Hammer","Spear") var current_melee_type : int
@export_enum("Pistol","Shotgun","Beam") var current_ranged_type : int

var level : int = 1
var required_xp : int = 10
var current_xp : int = 0

const TIME_TO_CHARGE : float = 0.2
var available_dash : float 
var ammo : int
var health : int 
var reversed : int
var can_dash : bool = true
var can_attack : bool = true
var can_combo : bool
var speed : int
var mouse_position : Vector2
var input_direction : Vector2
var attack_cooldown : float
var charge_transition_time = TIME_TO_CHARGE
#Array of action states that can happen while running
const ACTION_STATES = ["Attack", "Idle", "AttackCombo", "Shoot", "AttackChargeUp", "ChargeAttack"]

func _ready() -> void:
	_set_melee_weapon()
	speed = base_stats.speed
	available_dash = max_dash
	ammo = max_ammo
	health = base_stats.max_health
	reversed = 1

func _physics_process(delta: float) -> void:
	if (available_dash < max_dash):
		available_dash += 0.7 * delta
		
	attack_cooldown -= delta
	move_player()
	handle_transitions(delta)
	animation_update()
		

func _add_ammo():
	if ammo < max_ammo:
		ammo += melee_weapon.melee_resource.ammo_gained
		
func move_player():
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed	* reversed
	move_and_slide()

func handle_transitions(delta : float):
	mouse_position = (global_position - get_global_mouse_position()).normalized()*-1
 	

	if Input.is_action_just_pressed("dash") and available_dash >= 1 and velocity != Vector2.ZERO and can_dash:
		state_machine.on_state_transition(state_machine.current_state, "dash", {"direction": velocity, "speed": base_stats.speed})
	
	if Input.is_action_pressed("attack") and can_attack and state_machine.current_state.name != "Dash":
		charge_transition_time -= delta
		if charge_transition_time <= 0 and melee_weapon.melee_resource.can_charge:
			state_machine.on_state_transition(state_machine.current_state, "AttackChargeUp", {"mouse_position": mouse_position})
		 

	if Input.is_action_just_released("attack") and can_attack and state_machine.current_state.name != "Dash":
		var new_state
		if can_combo and state_machine.current_state.name != "AttackCombo":
			new_state = "AttackCombo"
		else:
			new_state = "Attack"
		
		charge_transition_time = TIME_TO_CHARGE
		state_machine.on_state_transition(state_machine.current_state, new_state, {"mouse_position": mouse_position})
		
	
	#if Input.is_action_just_pressed("attack") and can_attack and state_machine.current_state.name != "Dash":
		#var new_state = "attackcombo" if can_combo and state_machine.current_state.name != "AttackCombo" else "attack"
		#state_machine.on_state_transition(state_machine.current_state, new_state, {"mouse_position": mouse_position})
		
	if Input.is_action_pressed("shoot") and state_machine.current_state.name != "Shoot"  and state_machine.current_state.name != "Dash":
		state_machine.on_state_transition(state_machine.current_state, "shoot", {"mouse_position": mouse_position})

# Transition to Idle only if not moving and not in an active action state
	if velocity == Vector2.ZERO and input_direction == Vector2.ZERO and state_machine.current_state.name not in ACTION_STATES:
		state_machine.on_state_transition(state_machine.current_state, "idle")

func animation_update():	
	animation_tree.set("parameters/"+_get_animation_tree_name()+"/StateMachine/Run/blend_position", velocity)

func attack_cooldown_timeout() -> void:
	can_attack = true

func combo_timer_timeout() -> void:
	can_combo = false
	
func xp_gained(amount: int) -> void:
	current_xp += amount

	while current_xp >= required_xp:  # Handle multiple level-ups
		current_xp -= required_xp
		level += 1
		print("LEVEL UP! New Level: %d" % level)
		level_up.emit()
		required_xp = ceil(required_xp * 1.5)  # Convert to int to avoid decimal values

	print("Current XP: %d / %d" % [current_xp, required_xp])
	
func _get_melee_weapon() -> Node2D:
	return melee_weapon

func _set_melee_weapon() -> void:
	melee_weapon._on_weapon_change(current_melee_type)

func _set_ranged_weapon() -> void:
	ranged_weapon._on_weapon_change(current_ranged_type)

func _get_animation_tree_name() -> String:
	match current_melee_type:
		0:
			return "SwordAnimationTree"
		1:
			return "HammerAnimationTree"
		2:
			return "SpearAnimationTree"
	return ""
