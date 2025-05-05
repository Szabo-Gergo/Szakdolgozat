extends Resource
class_name SpawnInfo

@export var enemy: PackedScene
@export_range(0,1) var elite_chance: float
@export var spawn_amount: int
@export_enum("NONE","STRONG","FAST","HEALER","TANK") var elite_type : String
