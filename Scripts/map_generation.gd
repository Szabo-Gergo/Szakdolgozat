extends Node2D

@onready var trees_and_bushes: TileMapLayer = $Trees_and_Bushes
@onready var ground_decorations: TileMapLayer = $Ground_Decorations
@onready var player: CharacterBody2D = $"../Player"

@export var noise_texture : NoiseTexture2D
@export var generation_size : Vector2
@export var delete_distance : int

@export var generation_radius : int

var loaded_chunks : Array
var player_tile_position : Vector2i
 
func _ready() -> void:
	noise_texture.noise.set("seed", randi())
	loaded_chunks.append(Vector2(0,0))
	
func _process(delta: float) -> void:
	
	var gen_position : Vector2 = ground_decorations.local_to_map(player.position/generation_size)
	
	for y in range(-generation_radius, generation_radius + 1):
		for x in range(-generation_radius, generation_radius + 1):
			grass_gen((gen_position+Vector2(x,y))*generation_size)	
	
	deload(gen_position*generation_size)


func grass_gen(pos):
		for y in range(pos.y, pos.y + generation_size.y):
			for x in range(pos.x, pos.x+generation_size.x):
				var noise_val = noise_texture.noise.get_noise_2d(x, y)
				if noise_val > 0:
					ground_decorations.set_cell(Vector2(x,y), 0, Vector2(0,0))
				else:
					ground_decorations.set_cell(Vector2(x,y), 0, Vector2(1,0))
		
		if pos not in loaded_chunks:
			loaded_chunks.append(pos)
		

func deload(pos : Vector2):
	for chunk in loaded_chunks:		
		if pos.distance_to(chunk) > delete_distance:
			clear_chunk(chunk)
			loaded_chunks.erase(chunk)
			
			
func clear_chunk(pos):
	for y in range(pos.y,pos.y+generation_size.y):
		for x in range(pos.x, pos.x+generation_size.x):
			ground_decorations.set_cell(Vector2(x,y), -1, Vector2(-1,-1))
	
