extends Node2D
class_name Health_Component
signal death

@export_category("Base Health Component")
@export var stat_sheet : BaseStats
@export var health_bar : ProgressBar 

@export var sprite : Sprite2D
@export var damage_number_component : DamageNumberComponent
@export var state_machine : StateMachine

@export_category("Player Health")
@export var is_player_health_component: bool
@export var armor_regen_wait_time : float
@export var armor_regen_rate : float = 1

@onready var GUI_health_bar: ProgressBar = $"../Hud/VBoxContainer/BasicHealthBar"
var health : int
var armor : int
var can_stagger : bool
var armor_regenerating : bool = false
var armor_regen_duration : float = 1
var armor_regen_time : float = 0

func _ready() -> void:
	var parent = get_parent()
	if is_player_health_component:
		stat_sheet = %Outfit.outfit_resource as OutfitResource
		
	health = stat_sheet.max_health
	armor = stat_sheet.max_armor
	
	if armor != 0:
		can_stagger = false
	else:
		can_stagger = true
	

func deal_damage(damage):	
	if armor > 0:
		can_stagger = false
		if abs(damage) <= armor:
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
	
	check_health()
	health_bar.update_health_points()
	if is_player_health_component:
		GUI_health_bar.update_health_points()

	number_pop_up(damage, false)
	flash(0.2)

func healing(healing_amount):
	if health == stat_sheet.max_health or health == 0 or healing_amount < 0:
		return
		
	health += healing_amount
	
	if health > stat_sheet.max_health:
		healing_amount = healing_amount - (health - stat_sheet.max_health)
		health = stat_sheet.max_health
	
	health_bar.update_health_points()
	number_pop_up(healing_amount, true)
	

func flash(time):
	if !is_player_health_component:
		sprite.material.set("shader_parameter/flash_opacity", 1)
		await get_tree().create_timer(time).timeout
		sprite.material.set("shader_parameter/flash_opacity", 0)

func number_pop_up(value: int, is_healing: bool):
	if damage_number_component != null:
		damage_number_component.display_damage(value, is_healing)
	
func check_health():
	if health + armor <= 0: 
		state_machine.on_state_transition(state_machine.current_state,"Death")
	
	if is_player_health_component and armor < stat_sheet.max_armor:
		armor_regenerating = false
		$ArmorCooldownTimer.start()
		armor_regen_time = 0

func _on_armor_cooldown_timer_timeout() -> void:
	_set_armor_regen()
	
	
var armor_start = 0
func _process(delta: float) -> void:
	if armor_regenerating:
		armor_regen_time += delta
		var regen_percent = armor_regen_time / armor_regen_duration
		regen_percent = clamp(regen_percent, 0, 1)
		armor = lerp(armor_start, stat_sheet.max_armor, regen_percent)
		health_bar.update_health_points()
		GUI_health_bar.update_health_points()
		
		if regen_percent == 1:
			armor_regenerating = false
		
func _set_armor_regen():
	armor_start = armor
	armor_regen_duration = (stat_sheet.max_armor - armor)/armor_regen_rate
	armor_regen_time = 0
	armor_regenerating = true
