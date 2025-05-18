extends Control

@export var enemies_defeated_number : Label
@export var time_number : float
@export var upgrade_material_gained : Label


func _ready() -> void:
	RuntimeSaves.run_started = false
	time_number = RuntimeSaves.game_time
	%TimeTextNumber.text = format_time()
	%EnemiesDefeatedNumber.text = str(RuntimeSaves.enemies_defeated)
	calculate_material_gain()

func calculate_material_gain():
	var gain_boost: float = RuntimeSaves.spawner_modifiers.upgrade_material_boost
	var enemies_defeated: int = RuntimeSaves.enemies_defeated
	var time_survived_sec: float = RuntimeSaves.game_time
	
	var max_time_sec: float = 600.0	
	var base_material_per_enemy: float = 0.1  # very small, tweak as needed

	var base_amount: float = enemies_defeated * base_material_per_enemy
	var time_multiplier: float = 1.0 + clamp(time_survived_sec / max_time_sec, 0.0, 1.0)
	
	print(base_amount)
	print(time_multiplier)
	print(gain_boost)
	
	var total_amount: int = round(base_amount * time_multiplier * gain_boost)
	print(total_amount)
	
	%UpgradeMaterialGainedNumber.text = str(total_amount)
	RuntimeSaves.player_stats.gain_currency(total_amount)
	
func format_time() -> String:
	var total_seconds = int(time_number)
	var minutes = total_seconds / 60
	var secs = total_seconds % 60
	return "%d:%02d" % [minutes, secs]

func _on_back_to_hub_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/UI/main_menu_screen.tscn")
