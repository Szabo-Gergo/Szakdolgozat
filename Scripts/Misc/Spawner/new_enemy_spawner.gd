extends Node2D

@export var player: Node2D
@export var spawn_radius: float = 400.0
@export var min_spawn_distance: float = 200.0
@export var max_enemies: int = 10000
@export var waves: Array[WaveResource]
@export var filler_wave: WaveResource
@export var On: bool = true

var active_wave: WaveResource
var enemies: Array[Node2D] = []
var current_wave_index: int = 0
var wave_timer: float = 0.0
var spawner_modifier: SpawnerModifierStrategy

func _ready() -> void:
	_init_spawner_modifier()
	_start_next_wave()


func _process(delta: float) -> void:
	if !active_wave or !On:
		return

	wave_timer += delta

	if _should_activate_filler_wave():
		_activate_filler_wave()
	elif _should_start_next_wave():
		_start_next_wave()


# Initialization
func _init_spawner_modifier() -> void:
	spawner_modifier = ResourceLoader.load("res://Resources/spawner_modifier.tres", "SpawnerModifierStrategy")
	spawner_modifier.apply_to_player(player)

	for wave in waves:
		spawner_modifier.apply_to_wave(wave)

	if filler_wave:
		spawner_modifier.apply_to_wave(filler_wave)


# Condition Checks
func _should_activate_filler_wave() -> bool:
	return enemies.is_empty() and wave_timer < active_wave.duration and !active_wave.is_filler_wave

func _should_start_next_wave() -> bool:
	return wave_timer >= active_wave.duration and enemies.is_empty()


# Wave Control
func _start_next_wave() -> void:
	if current_wave_index >= waves.size():
		return

	active_wave = waves[current_wave_index]
	wave_timer = 0.0
	current_wave_index += 1

	_spawn_wave_enemies(active_wave)


func _activate_filler_wave() -> void:
	active_wave = filler_wave
	_spawn_wave_enemies(active_wave)


# -----------------------------
# Enemy Spawning
# -----------------------------
func _spawn_wave_enemies(wave: WaveResource) -> void:
	for spawn_info in wave.enemy_info:
		var remaining_capacity = max_enemies - enemies.size()
		var enemies_to_spawn = min(spawn_info.spawn_amount, remaining_capacity)

		for i in enemies_to_spawn:
			await _spawn_single_enemy(spawn_info)
			await get_tree().create_timer(0.2).timeout


func _spawn_single_enemy(spawn_info: SpawnInfo) -> void:
	if enemies.size() >= max_enemies:
		return

	var enemy = spawn_info.enemy.instantiate()
	spawner_modifier.apply_to_enemy(enemy)

	var is_elite = randf() <= spawn_info.elite_chance
	if is_elite:
		_apply_elite_strategy(enemy, spawn_info.elite_type)

	enemy.global_position = _get_spawn_position()
	add_child(enemy)
	enemies.append(enemy)

	# Remove from list when killed
	enemy.connect("tree_exited", func(): enemies.erase(enemy))


func _get_spawn_position() -> Vector2:
	var angle = randf() * TAU
	var distance = randf_range(min_spawn_distance, spawn_radius)
	return player.global_position + Vector2(cos(angle), sin(angle)) * distance


# -----------------------------
# Elite Handling
# -----------------------------
func _apply_elite_strategy(enemy: Node2D, elite_type: String) -> void:
	var elite_strategy: BaseEliteStrategy

	match elite_type:
		"FAST":
			elite_strategy = FastEliteStrategy.new()
		"STRONG":
			elite_strategy = StrongEliteStrategy.new()
		"HEALER":
			elite_strategy = HealerEliteStrategy.new()
		"TANK":
			elite_strategy = TankEliteStrategy.new()
		_:
			return  # Unknown type

	elite_strategy.apply_modifier(enemy)
