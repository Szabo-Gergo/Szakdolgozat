extends Node

@export var player_stats : PlayerStats
@export var spawner_modifiers : SpawnerModifierStrategy
var game_time : float = 0
var run_started : bool = false
var enemies_defeated : int = 0
var outfit_initialized : bool = false

func _init() -> void:
	player_stats = ResourceLoader.load("res://Resources/Player.tres")
	spawner_modifiers = ResourceLoader.load("res://Resources/spawner_modifier.tres")

func _process(delta: float) -> void:
	if run_started:
		game_time += delta

func reload_resoures():
	player_stats = ResourceLoader.load("res://Resources/Player.tres")
	spawner_modifiers = ResourceLoader.load("res://Resources/spawner_modifier.tres")

func save_resources():
	ResourceSaver.save(player_stats, "res://Resources/Player.tres")
	ResourceSaver.save(spawner_modifiers, "res://Resources/spawner_modifier.tres")

func reset_spawner_modifier():
	for challange in spawner_modifiers.challange_effects:
		challange.value = 0
	
	save_resources()
