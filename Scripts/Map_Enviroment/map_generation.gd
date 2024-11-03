extends Node2D

@onready var ground: TileMapLayer = $Ground
@onready var ground_decorations: TileMapLayer = $Ground_Decorations
@onready var trees: TileMapLayer = $Trees
@onready var player: CharacterBody2D = $"../Player"

@export_category("Generation noises")
@export var generation_noise : NoiseTexture2D


@export_category("Generation values")
@export var generation_size : Vector2
@export var delete_distance : int
@export var generation_radius : int
@export_range(-1, 1) var decor_range : float
@export_range(-1, 1) var tree_range : float

@onready var color_rect: ColorRect = %ColorRect

#Chunk handler variables
var loaded_chunks : Array
var player_tile_position : Vector2i

# Atlas coords
var ground_tile_atlas_coords : Array
var decoration_tile_atlas_coords : Array
var tree_tile_atlas_coords : Array

func _ready() -> void:
	generation_noise.noise.set("seed", randi())
	var shadow_noise = color_rect.material.get("shader_parameter/noise_texture")
	shadow_noise.noise.set("seed", randi())
	
	ground_tile_atlas_coords = [
								Vector2i(36,8),Vector2i(36,10),Vector2i(36,12),Vector2i(36,14),
								Vector2i(38,4),Vector2i(38,10),Vector2i(38,12),Vector2i(38,14),
								Vector2i(40,2),Vector2i(40,4),Vector2i(40,6),Vector2i(40,10),Vector2i(40,12),Vector2i(40,14),
								Vector2i(42,4),Vector2i(42,10),Vector2i(42,12),Vector2i(42,14),
								Vector2i(44,8),Vector2i(44,10),Vector2i(44,12),Vector2i(44,14)
								]
								
	decoration_tile_atlas_coords = [
									Vector2i(0,8),Vector2i(4,8),Vector2i(8,8),Vector2i(11,8),
									Vector2i(7,10),Vector2i(9,10),Vector2i(12,10),
									Vector2i(7,13),Vector2i(10,13),Vector2i(12,13),
									Vector2i(0,16),Vector2i(0,18),Vector2i(0,20),
									Vector2i(3,16),Vector2i(3,18),Vector2i(3,20),
									Vector2i(7,16),Vector2i(7,18),Vector2i(7,20),
									Vector2i(11,16),Vector2i(11,18),Vector2i(11,20),
									]
									
	tree_tile_atlas_coords =[Vector2i(0,0),Vector2i(5,0),Vector2i(11,0),Vector2i(0,10),Vector2i(4,11)]
	

func _process(_delta: float) -> void:
	var gen_position : Vector2 = ground_decorations.local_to_map(player.position/generation_size)
	for y in range(-generation_radius, generation_radius + 1):
		for x in range(-generation_radius, generation_radius + 1):
			if (gen_position+Vector2(x,y))*generation_size not in loaded_chunks:
				generation(gen_position+Vector2(x,y))	
				
	deload(gen_position*generation_size)


func generation(pos):
	pos *= generation_size
	
	for y in range(pos.y, pos.y + generation_size.y):
		for x in range(pos.x, pos.x+generation_size.x):
			ground_gen(x,y)
			ground_decoration_gen(x,y)
			tree_gen(x,y)

	if pos not in loaded_chunks:
		loaded_chunks.append(pos)

func ground_gen(x,y):	
	ground.set_cell(Vector2(x,y), 0, ground_tile_atlas_coords[randi()%ground_tile_atlas_coords.size()])
	
func ground_decoration_gen(x,y):
	var decoration_noise_val = generation_noise.noise.get_noise_2d(x,y)
	var random_decor = decoration_tile_atlas_coords[randi()%decoration_tile_atlas_coords.size()]
	
	if decoration_noise_val > decor_range and decoration_noise_val < tree_range:
		ground_decorations.set_cell(Vector2(x,y), 0, random_decor)
	


var array = []

func tree_gen(x,y):
	var tree_noise_val = generation_noise.noise.get_noise_2d(x,y)
	var random_tree_tile = tree_tile_atlas_coords[randi()%tree_tile_atlas_coords.size()]
	array.append(tree_noise_val)
	if tree_noise_val > tree_range:
		trees.set_cell(Vector2(x,y), 0, random_tree_tile)



func deload(pos : Vector2):
	for chunk in loaded_chunks:		
		if pos.distance_to(chunk) > delete_distance:
			clear_chunk(chunk)
			loaded_chunks.erase(chunk)
			
func clear_chunk(pos):
	for y in range(pos.y,pos.y+generation_size.y):
		for x in range(pos.x, pos.x+generation_size.x):
			ground.set_cell(Vector2(x,y), -1, Vector2(-1,-1))
			ground_decorations.set_cell(Vector2(x,y), -1, Vector2(-1,-1))
			trees.set_cell(Vector2(x,y), -1, Vector2(-1,-1))
