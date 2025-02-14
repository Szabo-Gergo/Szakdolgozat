extends Node2D

@export var player: Node2D  # Reference to player
@export var spawn_radius: float = 400.0
@export var min_spawn_distance: float = 200.0
@export var max_enemies: int = 50
@export var waves: Array[WaveResource]  # List of waves
@export var filler_wave: WaveResource  # Used when main wave ends early
@export var On : bool = true
var elite_modifier: EliteModifiers
var active_wave: WaveResource
var enemies: Array[Node2D] = []
var current_wave_index: int = 0
var wave_timer: float = 0.0

func _ready():
	elite_modifier = EliteModifiers.new()
	start_next_wave()

func _process(delta):
	if !active_wave:
		return
	wave_timer += delta
	
	if On:
		if enemies.is_empty() and wave_timer < active_wave.duration and !active_wave.is_filler_wave:
			activate_filler_wave()
		if wave_timer >= active_wave.duration and enemies.is_empty():
			start_next_wave()

func start_next_wave():
	if current_wave_index >= waves.size():
		print("All waves completed!")
		return

	active_wave = waves[current_wave_index]
	wave_timer = 0.0
	current_wave_index += 1

	spawn_enemies(active_wave)

func activate_filler_wave():
	print("Activating filler wave...")
	active_wave = filler_wave
	spawn_enemies(active_wave)

#Get the number of enemies that should spawn
func spawn_enemies(wave: WaveResource):
	for spawn_info in wave.enemy_info:
		var enemies_to_spawn = min(spawn_info.spawn_amount, max_enemies - enemies.size())
		
		for i in range(enemies_to_spawn):
			spawn_enemy(spawn_info)
			await get_tree().create_timer(0.2).timeout  # Delay to prevent lag

func spawn_enemy(spawn_info: Spawn_Info):
	if enemies.size() >= max_enemies:
		return
	
	var is_elite = randf() <= spawn_info.elite_chance
	var enemy_scene = spawn_info.enemy.instantiate()
	
	# Apply elite modifications
	if is_elite:
		elite_modifier.apply_elite_modifiers(enemy_scene, spawn_info.elite_type)
	
	enemy_scene.global_position = get_spawn_position()
	
	add_child(enemy_scene)
	enemies.append(enemy_scene)
	enemy_scene.connect("tree_exited", func(): on_enemy_removed(enemy_scene))

func get_spawn_position() -> Vector2:
	var angle = randf() * TAU
	var distance = randf_range(min_spawn_distance, spawn_radius)
	return player.global_position + Vector2(cos(angle), sin(angle)) * distance

func on_enemy_removed(enemy):
	enemies.erase(enemy)
