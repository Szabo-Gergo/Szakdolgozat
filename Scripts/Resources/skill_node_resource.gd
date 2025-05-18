extends Resource
class_name SkillNodeResource

@export var texture : CompressedTexture2D
@export var upgrade_cost : int = 10
@export var current_level : int = 0
@export var max_level : int
@export var is_locked : bool
@export var is_finished : bool
@export var upgrades_per_level : Array[PermanentMeleeStatStrategy]
@export var ui_node_id : String
