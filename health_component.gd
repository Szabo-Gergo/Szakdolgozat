extends Node2D
class_name Health_Component

@export_category("Component")
@export var stat_sheet : BaseStats
@export var health_bar : Panel
@export var sprite : Sprite2D
@export var damage_number_component : DamageNumberComponent
@export var state_machine : StateMachine

var health : int
var armor : int
var can_stagger : bool

func _ready() -> void:
	# Get the parent node
	var parent = get_parent()

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

	health_bar.update_health_points()
	damage_pop_up(damage)
	flash(0.2)
	check_health()
	
func flash(time):
	sprite.material.set("shader_parameter/flash_opacity", 1)
	await get_tree().create_timer(time).timeout
	sprite.material.set("shader_parameter/flash_opacity", 0)

func damage_pop_up(damage: int):
	damage_number_component.display_damage(damage, false)
	
func check_health():	
	health_bar.visible = true
	if health + armor <= 0: 
		state_machine.current_state.transition.emit(state_machine.current_state, "Death")
		
