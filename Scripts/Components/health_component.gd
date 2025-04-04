extends Node2D
class_name Health_Component
signal death

@export_category("Component")
@export var stat_sheet : BaseStats
@export var is_player_health_component: bool
@export var health_bar : ProgressBar 

@export var sprite : Sprite2D
@export var damage_number_component : DamageNumberComponent
@export var state_machine : StateMachine

var GUI_health_bar: ProgressBar
var health : int
var armor : int
var can_stagger : bool

func _ready() -> void:
	var parent = get_parent()

	health = stat_sheet.max_health
	armor = stat_sheet.max_armor

	if is_player_health_component:
		GUI_health_bar = get_node("../../GameUILayer/VBoxContainer/BasicHealthBar")

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
	
	print("\nHealth in HealthComponent")
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
