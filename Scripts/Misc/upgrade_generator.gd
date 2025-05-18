extends Node
class_name UpgradeGenerator

enum UPGRADE_TYPE { POSITIVE, SACRIFICE }
enum TARGET_TYPE { MELEE, RANGED, OUTFIT }
enum RARITY { COMMON, RARE, EPIC, LEGENDARY }
enum STRATEGY_TYPE { PERMANENT, TEMPORARY }

var rarity_chances: Dictionary = {
	RARITY.COMMON: 60,
	RARITY.RARE: 25,
	RARITY.EPIC: 10,
	RARITY.LEGENDARY: 5
}

var amount_chances: Dictionary = {
	1: 40,
	2: 40,
	3: 15,
	4: 5
}

var rarity_colors : Dictionary = {
	RARITY.COMMON: Color(0.945, 0.945, 0.945),
	RARITY.RARE: Color(0, 0.486, 0.957),
	RARITY.EPIC: Color(0.776, 0, 0.801),
	RARITY.LEGENDARY: Color(1, 0.566, 0.145),
}

@export var upgrade_type: UPGRADE_TYPE
@export var target_type: TARGET_TYPE
@export var rarity: RARITY = RARITY.COMMON
@export var strategy_type: STRATEGY_TYPE
@export var upgrade_amount: int = 1

func create_upgrade_strategy():
	var strategy = _create_strategy(strategy_type, target_type)

	if strategy_type == STRATEGY_TYPE.TEMPORARY:
		var duration = randf_range(15.0, 30.0)
		strategy.duration = duration

	_set_upgrade_amount()
	if strategy:
		_generate_upgrades(strategy, upgrade_type, upgrade_amount)
	return strategy

func _create_strategy(strategy_type: STRATEGY_TYPE, target_type: TARGET_TYPE) -> BaseStatModifierStrategy:
	match target_type:
		TARGET_TYPE.MELEE:
			return PermanentMeleeStatStrategy.new() if strategy_type == STRATEGY_TYPE.PERMANENT else TemporaryMeleeStatStrategy.new()
		TARGET_TYPE.RANGED:
			return PermenantProjectileStatStrategy.new() if strategy_type == STRATEGY_TYPE.PERMANENT else TemporaryProjectileStatStrategy.new()
		TARGET_TYPE.OUTFIT:
			return PermenantOutfitStatStrategy.new() if strategy_type == STRATEGY_TYPE.PERMANENT else TemporaryOutfitStatStrategy.new()
		_:
			return null
	
	

func _generate_upgrades(strategy: BaseStatModifierStrategy, upgrade_type: UPGRADE_TYPE, count: int):
	for i in range(count):
		var upgrade_by_target = _create_upgrade_by_target(target_type)
		if upgrade_by_target == null:
			continue

		var is_negative = upgrade_type == UPGRADE_TYPE.SACRIFICE and i >= count / 2
		upgrade_by_target.rarity = clamp(rarity - 1, 0, RARITY.size() - 1) if is_negative else rarity
		upgrade_by_target.generate_random_upgrade(is_negative)

		strategy.upgrades.append(upgrade_by_target)

func _create_upgrade_by_target(target: TARGET_TYPE) -> BaseUpgradeResource:
	match target:
		TARGET_TYPE.MELEE:
			return MeleeUpgradeResource.new()
		TARGET_TYPE.RANGED:
			return ProjectileUpgradeResource.new()
		TARGET_TYPE.OUTFIT:
			return OutfitUpgradeResource.new()
		_:
			return null

func set_random_rarity():
	var rand = randi_range(1, 100)
	var current = 0
	
	for rarity in rarity_chances.keys():
		current += rarity_chances[rarity]
		if rand <= current:
			self.rarity = rarity
			return
			
func _set_upgrade_amount():
	var rand = randi_range(1, 100)
	var current = 0
	
	for amount in amount_chances.keys():
		current += amount_chances[amount]
		if rand <= current:
			self.upgrade_amount = amount
			return
	
func get_rarity_color()-> Color:
	return rarity_colors.get(rarity)
