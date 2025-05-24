extends Node2D

@onready var ground: TileMapLayer = $Ground
@onready var ground_decorations: TileMapLayer = $Ground_Decorations
@onready var trees: TileMapLayer = $Trees
@onready var player: CharacterBody2D = $"../Player"
@onready var interactables: TileMapLayer = $InteractiveTiles
@onready var color_rect: ColorRect = %ColorRect
@onready var interactables_container: Node2D = $InteractablesContainer

@export_category("Generation Settings")
@export var generation_noise: NoiseTexture2D
@export var generation_size: Vector2i
@export var delete_distance: int = 3
@export var generation_radius: int = 1

@export_category("Range Values")
@export var decor_range: Vector2 = Vector2(0.0, 0.5)
@export var tree_range: Vector2 = Vector2(0.5, 0.7)
@export var interact_range: Vector2 = Vector2(0.7, 1.0)

@export var interactable_scenes: Array[PackedScene] = [
	preload("res://Scripts/Map_Enviroment/rune_stone.tscn")
]

var loaded_chunks: Array[Vector2i] = []

const tile_atlas = {
	"ground": [
		Vector2i(36,8), Vector2i(36,10), Vector2i(36,12), Vector2i(36,14),
		Vector2i(38,4), Vector2i(38,10), Vector2i(38,12), Vector2i(38,14),
		Vector2i(40,2), Vector2i(40,4), Vector2i(40,6), Vector2i(40,10),
		Vector2i(40,12), Vector2i(40,14), Vector2i(42,4), Vector2i(42,10),
		Vector2i(42,12), Vector2i(42,14), Vector2i(44,8), Vector2i(44,10),
		Vector2i(44,12), Vector2i(44,14)
	],
	"decorations": [
		Vector2i(0,8), Vector2i(4,8), Vector2i(8,8), Vector2i(11,8),
		Vector2i(7,10), Vector2i(9,10), Vector2i(12,10),
		Vector2i(7,13), Vector2i(10,13), Vector2i(12,13),
		Vector2i(0,16), Vector2i(0,18), Vector2i(0,20),
		Vector2i(3,16), Vector2i(3,18), Vector2i(3,20),
		Vector2i(7,16), Vector2i(7,18), Vector2i(7,20),
		Vector2i(11,16), Vector2i(11,18), Vector2i(11,20)
	],
	"trees": [
		Vector2i(0,0), Vector2i(5,0), Vector2i(11,0), Vector2i(0,10),
		Vector2i(4,11)
	]
}

func _ready() -> void:
	initialize_noise()

func _process(_delta: float) -> void:
	var gen_position: Vector2i = ground.local_to_map(player.position / Vector2(generation_size))
	update_chunks(gen_position)
	cleanup_chunks(gen_position)

func initialize_noise() -> void:
	generation_noise.noise.seed = randi()
	var shadow_noise = color_rect.material.get("shader_parameter/noise_texture")
	shadow_noise.noise.seed = randi()

func update_chunks(gen_position: Vector2i) -> void:
	for y in range(-generation_radius, generation_radius + 1):
		for x in range(-generation_radius, generation_radius + 1):
			var chunk_pos = gen_position + Vector2i(x, y)
			if not loaded_chunks.has(chunk_pos):
				generate_chunk(chunk_pos)

func generate_chunk(chunk_coords: Vector2i) -> void:
	var world_pos = chunk_coords * generation_size
	for y in range(world_pos.y, world_pos.y + generation_size.y):
		for x in range(world_pos.x, world_pos.x + generation_size.x):
			generate_tile(x, y, "ground")
			generate_tile(x, y, "decorations", decor_range)
			generate_tile(x, y, "trees", tree_range)
			generate_interactables(x, y)

	loaded_chunks.append(chunk_coords)

func generate_tile(x: int, y: int, tile_type: String, range_value: Vector2 = Vector2.ZERO) -> void:
	if range_value == Vector2.ZERO or (generation_noise.noise.get_noise_2d(x, y) >= range_value.x and generation_noise.noise.get_noise_2d(x, y) < range_value.y):
		var tile = tile_atlas[tile_type][randi() % tile_atlas[tile_type].size()]
		if tile_type == "ground":
			ground.set_cell(Vector2i(x, y), 0, tile)
		elif tile_type == "decorations":
			ground_decorations.set_cell(Vector2i(x, y), 0, tile)
		elif tile_type == "trees":
			trees.set_cell(Vector2i(x, y), 0, tile)

func generate_interactables(x: int, y: int) -> void:
	var val = generation_noise.noise.get_noise_2d(x, y)
	if val >= interact_range.x and val < interact_range.y and interactable_scenes.size() > 0:
		var scene_index = randi() % interactable_scenes.size()
		var instance = interactable_scenes[scene_index].instantiate()
		instance.position = ground.map_to_local(Vector2i(x, y))
		interactables_container.add_child(instance)

func cleanup_chunks(current_chunk: Vector2i) -> void:
	var chunks_to_remove: Array[Vector2i] = []
	for chunk in loaded_chunks:
		if chunk.distance_to(current_chunk) > delete_distance:
			clear_chunk(chunk)
			chunks_to_remove.append(chunk)
	for chunk in chunks_to_remove:
		loaded_chunks.erase(chunk)

func clear_chunk(chunk_coords: Vector2i) -> void:
	var world_pos = chunk_coords * generation_size
	for y in range(world_pos.y, world_pos.y + generation_size.y):
		for x in range(world_pos.x, world_pos.x + generation_size.x):
			var tile_pos = Vector2i(x, y)
			ground.set_cell(tile_pos, -1, Vector2i(-1, -1))
			ground_decorations.set_cell(tile_pos, -1, Vector2i(-1, -1))
			trees.set_cell(tile_pos, -1, Vector2i(-1, -1))
			interactables.set_cell(tile_pos, -1, Vector2i(-1, -1))

	for child in interactables_container.get_children():
		var local_map = ground.local_to_map(child.position) 
		if local_map.x >= world_pos.x and local_map.x < world_pos.x + generation_size.x and local_map.y >= world_pos.y and local_map.y < world_pos.y + generation_size.y: 
			child.queue_free()
