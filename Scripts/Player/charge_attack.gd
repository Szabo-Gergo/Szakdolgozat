extends Attack
class_name ChargeAttack

const ATTACK_TYPES = ["slash_projectile", "tornado"]

func enter(_inputs : Dictionary = {}):
	update_trail_position()
	
func physics_process(_delta: float):
	animation_tree.set("parameters/ChargeAttack/blend_position", mouse_position)
	
	
func _on_charge_attack_finished(anim_name: StringName) -> void:
	if  "ChargeAttack" in anim_name:
		transition.emit(self, "idle") 

func _on_enemy_hit(_body: Node2D) -> void:
	pass
