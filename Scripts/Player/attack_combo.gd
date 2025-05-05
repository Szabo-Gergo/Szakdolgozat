extends Attack
class_name AttackCombo

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"

func enter(_inputs : Dictionary = {}):
	player.speed *= 1.0 - (slow_percent / 100)
	update_trail_position()
	cooldown_timer.start()
	player.can_attack = false
	
func physics_process(delta: float) -> void:
	animation_update()

#	Dash check
	if Input.is_action_just_pressed("dash") and player.available_dash >= 1 and player.velocity != Vector2.ZERO:
		transition.emit(self, "Dash", {"direction" : mouse_position*player.base_stats.speed})
		


func _on_attack_combo_finished(anim_name: StringName) -> void:
	if "Combo" in anim_name:
		transition.emit(self, "idle") 

func animation_update():
	animation_tree.set("parameters/"+player._get_animation_tree_name()+"/StateMachine/Combo/BlendSpace2D/blend_position", mouse_position)


func _on_enemy_hit(_area: Area2D) -> void:
	pass
	
func exit():
	player.speed = player.outfit_node.outfit_resource.speed
	print()
	player.can_combo = false
