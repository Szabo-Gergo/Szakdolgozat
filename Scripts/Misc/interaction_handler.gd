extends Node

var tile_interactions = {
	"merchant": func(actor, value): open_shop(actor)
}

func interact_with_tile(tilemap: TileMap, tile_position, actor):
	var source_id = tilemap.get_cell_source_id(0, tile_position)
	if source_id == -1:
		return
	
	var interaction_type = tilemap.get_cell_tile_data(0, tile_position).get_custom_data("interaction_type")
	var interaction_value = tilemap.get_cell_tile_data(0, tile_position).get_custom_data("interaction_value")

	if interaction_type and tile_interactions.has(interaction_type):
		tile_interactions[interaction_type].call(actor, interaction_value)

func open_shop(actor):
	print("Opening shop for", actor)
