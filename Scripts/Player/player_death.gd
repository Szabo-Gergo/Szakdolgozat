extends State

func enter(_inputs : Dictionary = {}):
	get_tree().change_scene_to_file("res://Scenes/UI/game_over_screen.tscn")
