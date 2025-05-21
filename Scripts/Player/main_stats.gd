extends CharacterBody2D
class_name Player

signal level_up

@export_category("Stats")
@export var base_stats: PlayerStats
@export var health_component: Health_Component
@export var dash_recharge_speed: float

# Nodes
@onready var character_sprite: Sprite2D = %CharacterSprite
@onready var animation_tree = %AnimationTree
@onready var state_machine: StateMachine = $"State Machine"

#Stat Nodes
@onready var melee_weapon_node: MeleeWeapon = %MeleeWeapon
@onready var ranged_weapon_node: RangedWeapon = $RangedWeapon
@onready var outfit_node: Outfit = $Outfit

#UI Nodes
@onready var main_dash_point_container: PointContainer = %DashContainer
@onready var main_ammo_point_container: PointContainer = %AmmoContainer
@onready var xp_bar: ProgressBar = $Hud/XpContainer/XpBar
@onready var xp_label: Label = $Hud/XpContainer/XpLabel



# Player State
#XP
var level: int = 1
var required_xp: int = 10
var current_xp: int = 0

#Dash
var available_dash: float
var can_dash: bool = true
var dash_recharge: float = 0.0

#Ranged
var ammo: float
var mouse_position: Vector2

#Attack
var can_attack: bool = true
var can_combo: bool = false

#Movement
var direction_multiplier: int = 1
var speed: float
var input_direction: Vector2

#States that can 
const ACTION_STATES = ["Attack", "Idle", "AttackCombo", "Shoot"]

func _ready() -> void:
	base_stats = RuntimeSaves.player_stats
	_set_melee_weapon(base_stats.melee_weapon_type)
	_set_ranged_weapon(base_stats.ranged_weapon_type)
	_ui_setup()

	speed = outfit_node.outfit_resource.speed
	available_dash = outfit_node.outfit_resource.max_dash
	ammo = ranged_weapon_node.max_ammo

func _physics_process(delta: float) -> void:
	_handle_dash_recharge(delta)

	move_player()
	handle_transitions()
	update_animation()

func move_player() -> void:
	input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed * direction_multiplier
	move_and_slide()

func handle_transitions() -> void:
	mouse_position = (global_position - get_global_mouse_position()).normalized() * -1

	if Input.is_action_just_pressed("dash") and available_dash >= 1 and velocity != Vector2.ZERO and can_dash:
		state_machine.on_state_transition(state_machine.current_state, "dash", {"direction": velocity, "speed": speed})

	if Input.is_action_pressed("attack") and can_attack and state_machine.current_state.name != "Dash":
		var new_state = "AttackCombo" if (can_combo and state_machine.current_state.name != "AttackCombo") else "Attack"
		state_machine.on_state_transition(state_machine.current_state, new_state, {"mouse_position": mouse_position})

	if Input.is_action_pressed("shoot") and state_machine.current_state.name not in ["Shoot", "Dash"]:
		state_machine.on_state_transition(state_machine.current_state, "shoot", {"mouse_position": mouse_position})

	if velocity == Vector2.ZERO and input_direction == Vector2.ZERO and state_machine.current_state.name not in ACTION_STATES:
		state_machine.on_state_transition(state_machine.current_state, "idle")

func update_animation() -> void:
	animation_tree.set("parameters/%s/StateMachine/Run/blend_position" % _get_animation_tree_name(), velocity)

func _handle_dash_recharge(delta: float) -> void:
	if available_dash < outfit_node.outfit_resource.max_dash:
		dash_recharge += dash_recharge_speed * delta
		if dash_recharge >= 1.0:
			available_dash += 1
			dash_recharge = 0
			can_dash = true
			%DashPointContainer._increase_point(1)
			main_dash_point_container._increase_point(1)

func _add_ammo() -> void:
	if ammo < ranged_weapon_node.max_ammo:
		var old_ceiled = int(ceil(ammo))
		ammo += melee_weapon_node.melee_resource.ammo_gained
		ammo = min(ammo, ranged_weapon_node.max_ammo)
		var new_ceiled = int(ceil(ammo))
		main_ammo_point_container._increase_point(max(new_ceiled - old_ceiled, 0))

func xp_gained(amount: int) -> void:
	current_xp += amount

	while current_xp >= required_xp:
		current_xp -= required_xp
		level += 1
		required_xp = ceil(required_xp * 1.5)
		level_up.emit()

	_update_xp_ui()

func _update_xp_ui() -> void:
	xp_bar.max_value = required_xp
	xp_bar.value = current_xp
	xp_label.text = "Level %d" % level

# Timer callbacks
func attack_cooldown_timeout() -> void:
	can_attack = true

func combo_timer_timeout() -> void:
	can_combo = false

# Loadout setters
func _set_melee_weapon(value: int) -> void:
	melee_weapon_node._on_weapon_change(value)

func _set_ranged_weapon(value: int) -> void:
	ranged_weapon_node._on_weapon_change(value)

func _set_outfit(value: int) -> void:
	outfit_node._on_outfit_change(value)

# Getters
func _get_melee_weapon() -> Node2D:
	return melee_weapon_node

func _get_player_resource() -> PlayerStats:
	return base_stats

func _get_animation_tree_name() -> String:
	match base_stats.melee_weapon_type:
		0: return "SwordAnimationTree"
		1: return "HammerAnimationTree"
		2: return "SpearAnimationTree"
		_: return ""

func _ui_setup() -> void:
	_update_xp_ui()
