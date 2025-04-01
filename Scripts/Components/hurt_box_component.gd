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
	var is_hit : bool = false
		
	if is_melee_hitbox:
		is_hit = true
		damage = root.player.melee_weapon.melee_resource._get_damage()
	elif is_projectile_hitbox :	
		is_hit = true
		damage = root.player.ranged_weapon._get_projectile_resource().damage
	
	var will_survive = health_component.health - damage > 0
	
	#when the enemy can't stagger we handle the damage from here otherwise go the the damage state
	
	if is_hit:
		if will_survive and health_component.can_stagger:
			state_machine.on_state_transition(state_machine.current_state, "Damaged", {"state_origin": state_machine.current_state.name, "damage": damage})
			animation_tree.get("parameters/playback").travel("Damaged")
		else:
			health_component.deal_damage(damage)
