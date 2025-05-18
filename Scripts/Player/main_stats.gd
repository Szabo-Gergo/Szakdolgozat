extends CharacterBody2D
class_name Player
signal level_up


@export_category("Stats")
@export var base_stats : PlayerStats
@export var health_component : Health_Component
@export var dash_recharge_speed : float

@onready var melee_weapon_node: MeleeWeapon = %MeleeWeapon
@onready var ranged_weapon_node: RangedWeapon = $RangedWeapon
@onready var outfit_node: Outfit = $Outfit

@onready var main_dash_point_container: PointContainer = %DashContainer
@onready var main_ammo_point_container: PointContainer = %AmmoContainer
@onready var xp_bar: ProgressBar = $Hud/XpContainer/XpBar
@onready var xp_label: Label = $Hud/XpContainer/XpLabel
@onready var character_sprite: Sprite2D = %CharacterSprite
@onready var animation_tree = %AnimationTree
@onready var state_machine: StateMachine = $"State Machine"

var level : int = 1
var required_xp : int = 10
var current_xp : int = 0

var available_dash : float 
var ammo : float
var reversed : int
var can_dash : bool = true
var can_attack : bool = true
var can_combo : bool
var mouse_position : Vector2
var input_direction : Vector2
var attack_cooldown : float
var speed : float
#Array of action states that can happen while running
const ACTION_STATES = ["Attack", "Idle", "AttackCombo", "Shoot"]

func _ready() -> void:
	base_stats = RuntimeSaves.player_stats
	_set_melee_weapon(base_stats.melee_weapon_type)
	_set_ranged_weapon(base_stats.ranged_weapon_type)
	_ui_setup()
	speed = outfit_node.outfit_resource.speed
	available_dash = outfit_node.outfit_resource.max_dash
	ammo = ranged_weapon_node.max_ammo
	reversed = 1


var dash_recharge : float = 0
func _physics_process(delta: float) -> void:
	if (available_dash < outfit_node.outfit_resource.max_dash):
		dash_recharge += dash_recharge_speed * delta
		if dash_recharge >= 1:
			available_dash += 1
			%DashPointContainer._increase_point(1)
			main_dash_point_container._increase_point(1)
			can_dash = true
			dash_recharge = 0
		
		
	attack_cooldown -= delta
	move_player()
	handle_transitions(delta)
	animation_update()
		

func _add_ammo():
	if ammo < ranged_weapon_node.max_ammo:
		var old_ceiled = int(ceil(ammo))
		ammo += melee_weapon_node.melee_resource.ammo_gained
		
		if ammo >= ranged_weapon_node.max_ammo:
			ammo = ranged_weapon_node.max_ammo
			main_ammo_point_container._increase_point(ranged_weapon_node.max_ammo - old_ceiled)
		else:
			var new_ceiled = int(ceil(ammo))
			main_ammo_point_container._increase_point(max(new_ceiled - old_ceiled, 0))

		
func move_player():
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed	* reversed
	move_and_slide()

func handle_transitions(delta : float):
	mouse_position = (global_position - get_global_mouse_position()).normalized()*-1
 	

	if Input.is_action_just_pressed("dash") and available_dash >= 1 and velocity != Vector2.ZERO and can_dash:
		state_machine.on_state_transition(state_machine.current_state, "dash", {"direction": velocity, "speed": speed})
	
	if Input.is_action_pressed("attack") and can_attack and state_machine.current_state.name != "Dash":
		var new_state
		if can_combo and state_machine.current_state.name != "AttackCombo":
			new_state = "AttackCombo"
		else:
			new_state = "Attack"
		state_machine.on_state_transition(state_machine.current_state, new_state, {"mouse_position": mouse_position})
		
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

	while current_xp >= required_xp:
		current_xp -= required_xp
		level += 1
		level_up.emit()
		required_xp = ceil(required_xp * 1.5)
		xp_bar.max_value = required_xp
		xp_label.text = "Level "+str(level)
	
	xp_bar.value = current_xp
	print("Current XP: %d / %d" % [current_xp, required_xp])
	
func _get_melee_weapon() -> Node2D:
	return melee_weapon_node

func _set_melee_weapon(value : int) -> void:
	melee_weapon_node._on_weapon_change(value)

func _set_ranged_weapon(value : int) -> void:
	ranged_weapon_node._on_weapon_change(value)

func _set_outfit(value : int) -> void:
	outfit_node._on_outfit_change(value)
	

func _get_player_resource() -> PlayerStats:
	return base_stats

func _get_animation_tree_name() -> String:
	match base_stats.melee_weapon_type:
		0:
			return "SwordAnimationTree"
		1:
			return "HammerAnimationTree"
		2:
			return "SpearAnimationTree"
	return ""

func _ui_setup():
	xp_bar.max_value = required_xp
	xp_bar.value = current_xp
	xp_label.text = "Level "+str(level)
