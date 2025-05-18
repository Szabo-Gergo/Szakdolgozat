extends Control
class_name UpgradePicker

@export var picker_canvas_layer : CanvasLayer
@export var hud_canvas_layer : CanvasLayer

func _on_close_menu() -> void:
	get_tree().paused = false
	picker_canvas_layer.hide()
	hud_canvas_layer.show()


func _on_player_level_up() -> void:
	get_tree().paused = true
	hud_canvas_layer.hide()
	%MeleeUpgradeOption._generate_strategy()
	%RangedUpgradeOption._generate_strategy()
	%OutfitUpgradeOption._generate_strategy()
	picker_canvas_layer.show()
