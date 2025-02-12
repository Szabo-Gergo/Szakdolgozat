extends Basic_Enemy_Attack
@export var is_jumping : bool

func _on_hit_box_area_entered(area: Area2D) -> void:
	pass 
	
func physics_process(_delta: float):
	super.physics_process(_delta)
	if hit_connected():
		transition.emit(self, "Attached")

func hit_connected() -> bool:
	return root.global_position.distance_to(root.player.global_position) <= 10
		
