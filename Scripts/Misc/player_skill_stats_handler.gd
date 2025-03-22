extends Node

var upgrade_currency : int = 2000
var melee_weapon_index : int 
var secondary_weapon_index : int
var outfit_index : int
var damage : int 
var max_health : int 
var max_armor : int 
var speed : float 
var projectile_damage : int
var max_dash : int 
var max_ammo : int 
var can_charge : bool
var charge_attack_damage_multiplier : float
var health_component : Health_Component
var can_precision_charge : bool
var attack_speed : float

func use_currency(amount):
	if upgrade_currency-amount >= 0:
		upgrade_currency -= amount
		return true
	else:
		return false
		
func gain_currency(amount):
	if amount >= 0:
		upgrade_currency += amount
	
func set_damage(amount:int):
	pass

func set_speed(amount:int):
	pass
	
func set_max_health(amount:int):
	pass
	
#Armor for the player should act the same as health just it regenerates after
# a given time.
func set_max_armor(amount:int):
	pass
	
func set_projectile_damage(amount:int):
	pass
	
func set_max_dash(amount : int):
	pass
	
func set_max_ammo(amount : int):
	pass
	
func set_can_charge(state : bool):
	can_charge = state
	
func set_charge_attack_damage_multiplier(amount: float):
	pass
	
func set_can_precision_charge(state : bool):
	can_precision_charge = state

func set_attack_cooldown(amount : float):
	pass

func save_stats():
	pass
	
func load_stats():
	pass
