extends Control
class_name SkillTreeHandler

@export var trees: Array[SkillTreeResource]
@onready var ui_skill_nodes: Array[Node]

func _ready():
	ui_skill_nodes = find_children("", "SkillNode", true)
	load_all_trees()
	connect_skill_nodes()
	
#Connect the saved resources to the ui node with the same id.
func connect_skill_nodes():
	for tree in trees:
		for skill_node in tree.skill_nodes:
			for ui_skill_node in ui_skill_nodes:
				if ui_skill_node.node_id == skill_node.ui_node_id:
					ui_skill_node.load_resource(skill_node)

func save_all_trees():
	for tree in trees:
		tree.save_tree()

func load_all_trees():
	var loaded_trees: Array[SkillTreeResource] = []
	
	for tree in get_children():
		var loaded_tree = SkillTreeResource.load_tree(tree.name)
		
		if loaded_tree == null:
			loaded_tree = SkillTreeResource.create_tree(tree)
		
		loaded_trees.append(loaded_tree)
	
	trees = loaded_trees


func _on_upgrade_menu_closed() -> void:
	save_all_trees()
