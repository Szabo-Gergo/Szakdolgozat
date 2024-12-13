extends Node
@export_category("Base Stats")
@export var base_stats : BaseStats

@export_category("Side Stats")
@export var max_dash : int = 100000
@export var max_ammo : int = 6
@export var projectile_damage : int = 1

var available_dash : int 
var ammo : int
var health : int 
var reversed : int
var can_dash : bool

const CURSOR = preload("res://Spritesheets/Misc/cursor.png")
const AIM_CURSOR = preload("res://Spritesheets/Misc/aim_cursor.png")

func _ready() -> void:
	can_dash = true
	available_dash = max_dash
	ammo = max_ammo
	health = base_stats.max_health
	reversed = 1
	

func _physics_process(delta: float) -> void:
	if (available_dash < max_dash):
		available_dash += 0.7 * delta


func _add_health(new_health):
	health += new_health
	var max_health = base_stats.max_health
	if health >= max_health:
		health = max_health
	elif health <= 0:
		health = 0

func _add_ammo():
	if ammo < max_ammo:
		ammo += 1
