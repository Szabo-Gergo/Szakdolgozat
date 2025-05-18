extends Control
class_name UpgradePickerOption
signal close_menu

const OUTFIT_UPGRADE_ICON = preload("res://Spritesheets/Misc/OutfitUpgradeIcon.png")
const RANGED_UPGRADE_ICON = preload("res://Spritesheets/Misc/RangedUpgradeIcon.png")
const MELEE_UPGRADE_ICON = preload("res://Spritesheets/Misc/MeleeUpgradeIcon.png")

@export var target_type : UpgradeGenerator.TARGET_TYPE
@export var player : Player

@onready var upgrade_icon: TextureRect = %UpgradeIcon
@onready var upgrade_title: Label = %UpgradeTitle
@onready var upgrades: Label = %Upgrades

@onready var panel_container: PanelContainer = $MarginContainer/PanelContainer

var upgrade_generator : UpgradeGenerator 
var upgrade_strategy : BaseStatModifierStrategy

	
func _generate_strategy():
	upgrade_generator = UpgradeGenerator.new()
	upgrade_generator.set_random_rarity()
	upgrade_generator.target_type = target_type
	upgrade_generator.strategy_type = UpgradeGenerator.STRATEGY_TYPE.PERMANENT
	
	var rand = randi_range(0,100)
	var upgrade_type

	if rand < 65 :
		upgrade_type = UpgradeGenerator.UPGRADE_TYPE.POSITIVE
	else:
		upgrade_type = UpgradeGenerator.UPGRADE_TYPE.SACRIFICE

	upgrade_generator.upgrade_type = upgrade_type
	upgrade_strategy = upgrade_generator.create_upgrade_strategy()

	_ui_setup()

func _on_upgrade_chosen() -> void:
	match target_type:
		0:
			upgrade_strategy.apply_stat(player.melee_weapon_node)
		1:
			upgrade_strategy.apply_stat(player.ranged_weapon_node)
		2:
			upgrade_strategy.apply_stat(player.outfit_node)
	
	close_menu.emit()
	

func _ui_setup():
	var target_string = ""
	match target_type:
		UpgradeGenerator.TARGET_TYPE.MELEE:
			target_string = "Melee Upgrade"
			upgrade_icon.texture = MELEE_UPGRADE_ICON
		UpgradeGenerator.TARGET_TYPE.RANGED:
			target_string = "Projectile Upgrade"
			upgrade_icon.texture = RANGED_UPGRADE_ICON
		UpgradeGenerator.TARGET_TYPE.OUTFIT:
			target_string = "Outfit Upgrade"
			upgrade_icon.texture = OUTFIT_UPGRADE_ICON

	var panel = panel_container.get("theme_override_styles/panel")
	panel.border_color = upgrade_generator.get_rarity_color()
		
	upgrades.text = "\n"+str(upgrade_strategy)
	upgrade_title.text = target_string
	
