extends ProjectileChainComponent
class_name ElectricEffectComponent

@export var damage: int
@onready var shape = $CollisionShape2D

func _ready():	
	await get_tree().physics_frame
	await get_tree().physics_frame

	for enemy in get_overlapping_bodies():
		if enemy.is_in_group("Enemy") and enemy not in enemies_to_chain:
			enemies_to_chain.append(enemy)

	enemies_to_chain.sort_custom(self._sort_enemies)
	on_chain_effect()

func on_chain_effect():
	$Line2D.clear_points()
	$Line2D.add_point(to_local(global_position))
	
	for enemy in enemies_to_chain:	
		$Line2D.add_point(to_local(enemy.position))	
		await get_tree().create_timer(0.1).timeout
		chain_amount -= 1
		
		enemy.health_component.deal_damage(damage)
		enemies_to_chain.erase(enemy)
		
		if chain_amount == 0:
			queue_free()
		
	
