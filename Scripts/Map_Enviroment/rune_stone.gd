extends Node2D
class_name RuneStone

var upgrade_strategy : BaseStatModifierStrategy
var upgrade_generator : UpgradeGenerator
var target_type : UpgradeGenerator.TARGET_TYPE
var player : Player
var in_range : bool = false
const rune_offset : Array = [Vector2(-14,-5),Vector2(-11,4),Vector2(-9,-1)]
var is_usable : bool = true

func _ready() -> void:
	_generate_strategy()
	player = get_tree().get_first_node_in_group("Player")
	
	if player:
		print("Player found:", player.name)
	else:
		print("Player not found")
	
	_look_setup()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and is_usable:
		%Stone.material.set("shader_parameter/pixel_size", 1.5)
		in_range = true

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		%Stone.material.set("shader_parameter/pixel_size", 0)
		in_range = false

func _input(event: InputEvent) -> void:
	print(Input.is_action_just_pressed("interact") and in_range)
	if Input.is_action_just_pressed("interact") and in_range:
		match target_type:
			UpgradeGenerator.TARGET_TYPE.MELEE:
				upgrade_strategy.apply_stat(player.melee_weapon_node)
			UpgradeGenerator.TARGET_TYPE.RANGED:
				upgrade_strategy.apply_stat(player.ranged_weapon_node)
			UpgradeGenerator.TARGET_TYPE.OUTFIT:
				upgrade_strategy.apply_stat(player.outfit_node)
		_on_stone_used()
		_start_label_tween()

func _generate_strategy():
	upgrade_generator = UpgradeGenerator.new()
	upgrade_generator.set_random_rarity()
	target_type = _get_random_from_enum(UpgradeGenerator.TARGET_TYPE)
	upgrade_generator.target_type = target_type
	upgrade_generator.strategy_type = UpgradeGenerator.STRATEGY_TYPE.TEMPORARY
	
	var rand = randi_range(0,100)
	var upgrade_type

	if rand < 65 :
		upgrade_type = UpgradeGenerator.UPGRADE_TYPE.POSITIVE
	else:
		upgrade_type = UpgradeGenerator.UPGRADE_TYPE.SACRIFICE

	upgrade_generator.upgrade_type = upgrade_type
	upgrade_strategy = upgrade_generator.create_upgrade_strategy()
	%Label.text = str(upgrade_strategy)
	
func _get_random_from_enum(enum_type: Dictionary) -> int:
	var keys = enum_type.values()
	return keys[randi() % keys.size()]

func _look_setup():
	_set_stone()
	_set_rune()
	
func _set_rune():
	var rand = randi_range(0,7)
	%Rune.texture.region.position.x = 16*rand
	%Rune.position = rune_offset[int(%Stone.texture.region.position.x / 128)]
	%Rune.modulate = upgrade_generator.get_rarity_color()
	
func _set_stone():
	var atlas_offset = 0
	if upgrade_generator.upgrade_type == UpgradeGenerator.UPGRADE_TYPE.SACRIFICE:
		atlas_offset += 64
	
	match upgrade_generator.target_type:
		UpgradeGenerator.TARGET_TYPE.RANGED:
			atlas_offset += 128
		UpgradeGenerator.TARGET_TYPE.OUTFIT:
			atlas_offset += 256

	%Stone.texture.region.position.x = atlas_offset
	
func _start_label_tween():
	var tween = Tween.new()
	
	var current_y = %Label.position.y
	var target_y = current_y - 20.0
	%Label.visible = true

	tween = get_tree().create_tween()
	tween.tween_property(%Label, "position:y", target_y, 2.0).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(%Label, "modulate:a", 0.0, 5.0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(%Label, "hide"))


func _on_stone_used():
	is_usable = false
	$Area2D/CollisionShape2D.disabled = true
	%Stone.material.set("shader_parameter/pixel_size", 0)
	%Rune.modulate = Color(0.49, 0.49, 0.49, 0.588)
