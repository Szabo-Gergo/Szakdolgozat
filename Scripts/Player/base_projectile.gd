extends Node2D
class_name BaseProjectile

const EXPLOSION_COMPONENT = preload("res://Scenes/Components/explosion_component.tscn")
const CHAIN_COMPONENT = preload("res://Scenes/Components/projectille_chain_component.tscn")
const FORCE_COMPONENT = preload("res://Scenes/Components/force_area_component.tscn")

@export_category("Projectile Stats")
@export_enum("Enemy_Hurtbox", "Player_Hurtbox") var target_group : String
@export var animated_sprite : AnimatedSprite2D
@export var status_particle : GPUParticles2D
@export var stats_resource: ProjectileStatResource
var hit_enemies : Array[CharacterBody2D]
var traveled_distance : float
var current_pierce : int

var explosion_component : ExplosionComponent
var chain_component : ProjectileChainComponent
var force_component : ForceAreaComponent

func _process(delta: float) -> void:
	var direction = Vector2.RIGHT.rotated(rotation)
	position += direction * stats_resource.speed * delta
	
	traveled_distance += stats_resource.speed * delta
	if traveled_distance >= stats_resource.range:
		queue_free()
	

func _set_base_values():
	if stats_resource.is_flamethrower:
		status_particle = GPUParticles2D.new()
		status_particle.process_material = preload("res://Projectiles/flame_particle_material.tres")
		status_particle.explosiveness = 1
		status_particle.local_coords = true
		add_child(status_particle)
	else:
		animated_sprite.sprite_frames = stats_resource.sprite_frames
		animated_sprite.play(stats_resource.animation_name)
	
	if stats_resource.can_explode:
		explosion_component = EXPLOSION_COMPONENT.instantiate()
		explosion_component.damage = stats_resource.damage * stats_resource.explosion_damage_multipler
		explosion_component.range = stats_resource.explosion_range
		explosion_component.global_position = global_position
		add_child(explosion_component)
	
	
	if stats_resource.chain > 0:
		chain_component = CHAIN_COMPONENT.instantiate()
		chain_component.chain_amount = stats_resource.chain
		add_child(chain_component)
	
	
	if stats_resource.has_force_field:
		force_component = FORCE_COMPONENT.instantiate()
		force_component.force_range = stats_resource.force_range
		force_component.force_strength = stats_resource.force_strength
		force_component.is_pulling = stats_resource.force_is_pulling
		add_child(force_component)
		
	traveled_distance = 0.0
	current_pierce = stats_resource.piercing
	

func _on_damage_area_entered(area: Area2D) -> void:
	if area.is_in_group(target_group):
		var enemy = area.root
		if enemy not in hit_enemies:
			hit_enemies.append(enemy) 
			
		if chain_component != null and chain_component.chain_amount > 0:
			chain_component.chain(enemy)
			traveled_distance = 0
		
		if stats_resource.can_explode and explosion_component != null:
			explosion_component.global_position = global_position
			explosion_component.explode()
	
		if stats_resource.status_effect:
			stats_resource.status_effect.apply_effect(enemy, stats_resource.damage)
		
		current_pierce -= 1
		if current_pierce <= 0:
			queue_free()
