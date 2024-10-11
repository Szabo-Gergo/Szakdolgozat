extends Attack
class_name AttackCombo

@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
	

func enter(inputs : Dictionary = {}):
	charge_transition_limit = 0
	update_trail_position()

func physics_process(delta: float) -> void:
		animation_update()
#		Slide the player forward slightly
		character_body.velocity = mouse_position*slide_speed
		character_body.move_and_slide()

#		If the attack is held transition to the charge up
		if Input.is_action_pressed("attack"):
			charge_transition_limit += delta
			if charge_transition_limit >= 0.2:
				transition.emit(self, "AttackChargeUp", {"charge_time": charge_transition_limit})
		
		if Input.is_action_just_pressed("dash") and Global.available_dash >= 1 and character_body.velocity != Vector2.ZERO:
			transition.emit(self, "Dash", {"direction" : mouse_position*Global.player_speed})
			

func _on_attack_combo_finished(anim_name: StringName) -> void:
	if "Combo" in anim_name:
		transition.emit(self, "idle", {"attack_cooldown": 0.15}) 

func animation_update():
	animation_tree.set("parameters/Combo/blend_position", mouse_position)

func _on_enemy_hit(body: Node2D) -> void:
	pass
