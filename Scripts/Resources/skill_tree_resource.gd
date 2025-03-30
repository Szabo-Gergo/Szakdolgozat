extends Resource
class_name SkillTreeResource

@export var tree_name: String
@export var skill_nodes: Array[SkillNodeResource]

func save_tree():
	var save_path = "res://Resources/SkillTrees/" + tree_name + ".tres"
	ResourceSaver.save(self, save_path)

static func load_tree(tree_name: String) -> SkillTreeResource:
	var save_path = "res://Resources/SkillTrees/" + tree_name + ".tres"
	if ResourceLoader.exists(save_path):
		return ResourceLoader.load(save_path)
	return null  

static func create_tree(skill_tree_panel : Panel) -> SkillTreeResource:
	var ret = SkillTreeResource.new()
	ret.tree_name = skill_tree_panel.name
	
	var ui_skill_nodes = skill_tree_panel.find_children("", "SkillNode", true)
	for node in ui_skill_nodes:
		ret.skill_nodes.append(node.skill_resource)
	
	ret.save_tree()
	return ret
