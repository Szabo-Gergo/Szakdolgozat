extends Node
@export_category("Base Stats")
@export var base_stats : BaseStats

@export_category("Side Stats")
@export var max_dash : int = 100000
@export var max_ammo : int = 6
@export var projectile_damage : int = 5

var available_dash : int 
var ammo = 6
var health : int 

const CURSOR = preload("res://Spritesheets/Misc/cursor.png")
const AIM_CURSOR = preload("res://Spritesheets/Misc/aim_cursor.png")

func _ready() -> void:
	available_dash = max_dash
	ammo = 6
	health = base_stats._get_max_health()

	

func _physics_process(delta: float) -> void:
	if (available_dash < max_dash):
		available_dash += 0.7 * delta


func _add_health(new_health):
	health += new_health
	var max_health = base_stats._get_max_health()
	if health >= max_health:
		health = max_health
	elif health <= 0:
		health = 0

func _add_ammo():
	if ammo < max_ammo:
		ammo += 1
