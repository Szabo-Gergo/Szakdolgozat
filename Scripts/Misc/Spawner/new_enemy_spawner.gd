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
	start_next_wave()

func _process(delta: float) -> void:
	if !active_wave:
		return

	wave_timer += delta

	if On:
		if _should_activate_filler_wave():
			activate_filler_wave()
		elif _should_start_next_wave():
			start_next_wave()

# Initialization
func _init_spawner_modifier() -> void:
	spawner_modifier = ResourceLoader.load("res://Resources/spawner_modifier.tres", "SpawnerModifierStrategy")
	spawner_modifier.apply_to_player(player)

	for wave in waves:
		spawner_modifier.apply_to_wave(wave)

	if filler_wave:
		spawner_modifier.apply_to_wave(filler_wave)

# Conditions
func _should_activate_filler_wave() -> bool:
	return enemies.is_empty() and wave_timer < active_wave.duration and !active_wave.is_filler_wave

func _should_start_next_wave() -> bool:
	return wave_timer >= active_wave.duration and enemies.is_empty()

# Wave control
func start_next_wave() -> void:
	if current_wave_index >= waves.size():
		return

	active_wave = waves[current_wave_index]
	wave_timer = 0.0
	current_wave_index += 1

	spawn_enemies(active_wave)

func activate_filler_wave() -> void:
	print("Activating filler wave...")
	active_wave = filler_wave
	spawn_enemies(active_wave)

# Spawning
func spawn_enemies(wave: WaveResource) -> void:
	for spawn_info in wave.enemy_info:
		var enemies_to_spawn: int = min(spawn_info.spawn_amount, max_enemies - enemies.size())

		for i in range(enemies_to_spawn):
			spawn_enemy(spawn_info)
			await get_tree().create_timer(0.2).timeout

func spawn_enemy(spawn_info: SpawnInfo) -> void:
	if enemies.size() >= max_enemies:
		return

	var is_elite: bool = randf() <= spawn_info.elite_chance
	var enemy_scene = spawn_info.enemy.instantiate()
	spawner_modifier.apply_to_enemy(enemy_scene)

	if is_elite:
		apply_elite_strategy(enemy_scene, spawn_info.elite_type)

	enemy_scene.global_position = get_spawn_position()
	add_child(enemy_scene)
	enemies.append(enemy_scene)
	enemy_scene.connect("tree_exited", func(): on_enemy_removed(enemy_scene))

func get_spawn_position() -> Vector2:
	var angle = randf() * TAU
	var distance = randf_range(min_spawn_distance, spawn_radius)
	return player.global_position + Vector2(cos(angle), sin(angle)) * distance

func on_enemy_removed(enemy: Node2D) -> void:
	enemies.erase(enemy)

# Elite handling
func apply_elite_strategy(enemy_scene: Node2D, elite_type: String) -> void:
	var elite_strategy
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
			return  # Unknown type; skip

	elite_strategy.apply_modifier(enemy_scene)
