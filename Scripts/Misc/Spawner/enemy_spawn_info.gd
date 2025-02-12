extends Resource
class_name Spawn_Info

@export var enemy: PackedScene
@export_range(0,1) var elite_chance: float
@export var spawn_amount: int  # Total enemies in this wave
@export var elite_type: EliteModifiers.ELITE_TYPES 
