extends Resource
class_name PlayerStats


@export var upgrade_currency : int = 2000
@export_enum("Sword", "Hammer","Spear") var melee_weapon_type : int 
@export_enum("Pistol", "Shotgun", "FlameThrower", "Rocket") var ranged_weapon_type : int
@export_enum("Red", "Blue", "Green", "Purple") var outfit_type : int


func use_currency(amount) -> bool:
	if upgrade_currency-amount >= 0:
		upgrade_currency -= amount
		return true
	else:
		return false
		
func gain_currency(amount):
	if amount >= 0:
		upgrade_currency += amount
