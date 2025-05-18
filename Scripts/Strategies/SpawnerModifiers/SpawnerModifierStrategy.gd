extends Resource
class_name SpawnerModifierStrategy

@export var challange_effects : Array[ChallangeEffectResource]
@export var upgrade_material_boost : float = 0

func apply_to_enemy(enemy: Base_Enemy) -> void:
	var enemy_stats = enemy.base_stats
	for challange in challange_effects:
		match challange.effect_type:
			"enemy_armor":
				enemy_stats.max_armor *= challange.value+1
			"enemy_health":
				enemy_stats.max_health *= challange.value+1
			"enemy_speed":
				enemy_stats.speed *= challange.value+1
			_: pass 


func apply_to_player(player: Player) -> void:
	var player_stats = player.outfit_node.outfit_resource
	for challange in challange_effects:
		match challange.effect_type:
			"glass_cannon":
				if challange.value == 1:
					player_stats.max_health *= 0.2
					var melee_resource = player.melee_weapon_node.melee_resource
					melee_resource.damage *= 2
			"player_tank":
				if challange.value == 1:
					player_stats.max_health *= 2
					player_stats.speed *= 0.5
			_: pass


func apply_to_wave(wave: WaveResource) -> void:
	var spawn_infos = wave.enemy_info
	for challange in challange_effects:
		match challange.effect_type:
			"elite_chance":
				for enemy_info in spawn_infos:
					enemy_info.elite_chance *= challange.value + 1
			"enemy_spawn":
				for enemy_info in spawn_infos:
					enemy_info.spawn_amount *= challange.value + 1
			_: pass
