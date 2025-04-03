extends Node2D
class_name BaseProjectile

@export var sprite_frames : SpriteFrames

@export_category("Projectile Stats")
@export_enum("Enemy_Hurtbox", "Player_Hurtbox") var target_group : String
@export var animated_sprite : AnimatedSprite2D
var projectile_stats_resource: ProjectileStatResource
var hit_enemies : Array[CharacterBody2D]
var enemies_to_chain : Array[CharacterBody2D]
var traveled_distance : float
var current_pierce : int
var current_chain : int
var can_chain : bool

func _ready() -> void:
	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.play("default")


func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * projectile_stats_resource.speed * delta
	
	traveled_distance += projectile_stats_resource.speed * delta
	if traveled_distance >= projectile_stats_resource.range:
		queue_free()
	

func _set_base_values():
	if projectile_stats_resource.chain > 0:
		current_chain = projectile_stats_resource.chain
		$ChainArea/ChainShape.disabled = false
	
	traveled_distance = 0.0
	current_pierce = projectile_stats_resource.piercing
	

func _on_damage_area_entered(area: Area2D) -> void:
	if area.is_in_group(target_group):
		var enemy = area.get_parent()
		if enemy not in hit_enemies:
			hit_enemies.append(enemy) 
		
		if enemy in enemies_to_chain: 
			enemies_to_chain.erase(enemy)
			
		
		if current_chain > 0:
			get_closest_enemy_direction()
			current_chain -= 1
			traveled_distance = 0
			
		current_pierce -= 1
		if current_pierce <= 0:
			queue_free()

func get_closest_enemy_direction():
	if enemies_to_chain.is_empty():
		return
	
	var closest_enemy = null
	var closest_enemy_dist = INF
	
	for enemy in enemies_to_chain:
		var dist = global_position.distance_to(enemy.global_position)
		if dist < closest_enemy_dist:
			closest_enemy_dist = dist
			closest_enemy = enemy
			
	look_at(closest_enemy.global_position)


func _on_chain_area_entered(body: Node2D) -> void:
	if body.is_in_group("Enemy"):
		enemies_to_chain.append(body)
