extends Area2D
class_name HurtBoxComponent

@export var root : CharacterBody2D
@export var health_component : Health_Component
@export var state_machine : StateMachine
@export var animation_tree : AnimationTree

func _on_area_entered(area: Area2D) -> void:
	var is_melee_hitbox = area.is_in_group("Player_Melee_HitBox")
	var is_projectile_hitbox = area.is_in_group("Player_Projectile_HitBox")
	var damage = 0
		
	if is_melee_hitbox:
		damage = root.player.base_stats.damage
	elif is_projectile_hitbox:
		damage = root.player.projectile_damage
	
	#when the enemy can't stagger we handle the damage from here otherwise go the the damage state
	if health_component.can_stagger and (is_melee_hitbox or is_projectile_hitbox) and health_component.health-damage > 0:
		state_machine.on_state_transition(state_machine.current_state, "Damaged", {"state_origin": state_machine.current_state.name, "damage": damage})
		animation_tree.get("parameters/playback").travel("Damaged")	
	elif is_melee_hitbox or is_projectile_hitbox:
		health_component.deal_damage(damage)
	
