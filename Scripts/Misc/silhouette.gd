extends Sprite2D

@export var silhouette_node: Sprite2D

func _ready() -> void:
	silhouette_node.texture = texture
	silhouette_node.flip_h = flip_h
	silhouette_node.hframes = hframes
	silhouette_node.vframes = vframes
	silhouette_node.frame = frame


func _set(property: StringName, value: Variant) -> bool:
	match property:
		"flip_h":
			silhouette_node.flip_h = flip_h
		"frame":
			silhouette_node.frame = frame
		
	return false
