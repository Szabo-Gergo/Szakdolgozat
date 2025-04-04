extends BaseStats
class_name PlayerStats


@export var upgrade_currency : int = 2000
@export_enum("Sword", "Hammer","Spear") var melee_weapon_type : int 
@export var ranged_weapon_type : int
@export var outfit_index : int
@export var max_dash : int 


func use_currency(amount) -> bool:
	if upgrade_currency-amount >= 0:
		upgrade_currency -= amount
		return true
	else:
		return false
		
func gain_currency(amount):
	if amount >= 0:
		upgrade_currency += amount
