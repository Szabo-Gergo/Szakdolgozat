extends Node2D
class_name Health_Component
signal death

@export_category("Base Health Component")
@export var stat_sheet: BaseStats
@export var health_bar: ProgressBar
@export var sprite: Sprite2D
@export var damage_number_component: DamageNumberComponent
@export var state_machine: StateMachine

@export_category("Player Health")
@export var is_player_health_component: bool
@export var armor_regen_wait_time: float
@export var armor_regen_rate: float = 1

@onready var GUI_health_bar: ProgressBar = $"../Hud/VBoxContainer/BasicHealthBar"

var health: int
var armor: int
var can_stagger: bool
var armor_regenerating: bool = false
var armor_regen_time: float = 0
var armor_regen_duration: float = 1
var armor_start: int = 0

func _ready() -> void:
	if is_player_health_component:
		stat_sheet = %Outfit.outfit_resource as OutfitResource
	
	health = stat_sheet.max_health
	armor = stat_sheet.max_armor
	can_stagger = armor == 0


func deal_damage(damage: int) -> void:
	if armor > 0:
		can_stagger = false
		if damage <= armor:
			armor -= damage
		else:
			damage -= armor
			armor = 0
			health -= damage
			can_stagger = true
	else:
		can_stagger = true
		health -= damage

	health = max(health, 0)
	armor = max(armor, 0)

	update_health_ui()
	check_health()
	number_pop_up(damage, false)
	flash(0.2)


func healing(healing_amount: int) -> void:
	if healing_amount <= 0 or health == 0 or health >= stat_sheet.max_health:
		return

	health += healing_amount
	if health > stat_sheet.max_health:
		healing_amount -= (health - stat_sheet.max_health)
		health = stat_sheet.max_health

	update_health_ui()
	number_pop_up(healing_amount, true)


func flash(duration: float) -> void:
	if not is_player_health_component:
		sprite.material.set("shader_parameter/flash_opacity", 1)
		await get_tree().create_timer(duration).timeout
		sprite.material.set("shader_parameter/flash_opacity", 0)


func number_pop_up(value: int, is_healing: bool) -> void:
	if damage_number_component:
		damage_number_component.display_damage(value, is_healing)


func update_health_ui() -> void:
	health_bar.update_health_points()
	if is_player_health_component:
		GUI_health_bar.update_health_points()


func check_health() -> void:
	if health + armor <= 0:
		state_machine.on_state_transition(state_machine.current_state, "Death")

	if is_player_health_component and armor < stat_sheet.max_armor:
		start_armor_regen_cooldown()


func start_armor_regen_cooldown() -> void:
	armor_regenerating = false
	$ArmorCooldownTimer.start()
	armor_regen_time = 0


func _on_armor_cooldown_timer_timeout() -> void:
	start_armor_regeneration()


func start_armor_regeneration() -> void:
	armor_start = armor
	armor_regen_duration = float(stat_sheet.max_armor - armor) / armor_regen_rate
	armor_regen_time = 0
	armor_regenerating = true


func _process(delta: float) -> void:
	if armor_regenerating:
		armor_regen_time += delta
		var regen_percent = clamp(armor_regen_time / armor_regen_duration, 0, 1)
		armor = lerp(armor_start, stat_sheet.max_armor, regen_percent)
		update_health_ui()

		if regen_percent >= 1.0:
			armor_regenerating = false
