extends Node2D
class_name DamageNumberComponent

var label: Label
var tween: Tween
var is_displaying := false
var start_y: float

func _ready():
	label = Label.new()
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 10
	label.label_settings.outline_size = 1
	label.visible = false
	add_child(label)

func display_damage(damage: int, is_healing: bool):
	if is_healing:
		label.label_settings.outline_color = Color("00ff00")
	else:
		label.label_settings.outline_color = Color("ff0000")

	if is_displaying:
		label.text = str(int(label.text) + damage)
		label.modulate.a = 1.0
		_restart_animation()
	else:
		label.text = str(damage)
		label.position = Vector2(0, 0)
		start_y = label.position.y
		label.modulate.a = 1.0
		label.visible = true
		is_displaying = true
		_start_animation()

func _start_animation():
	if tween and tween.is_running():
		tween.kill()

	var current_y = label.position.y
	var target_y = max(start_y - 20.0, current_y - 20.0)

	tween = get_tree().create_tween()
	tween.tween_property(label, "position:y", target_y, 1.0).set_ease(Tween.EASE_OUT)
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.0).set_ease(Tween.EASE_IN_OUT)
	tween.tween_callback(Callable(self, "_on_tween_complete"))

func _restart_animation():
	_start_animation()

func _on_tween_complete():
	is_displaying = false
	label.visible = false
	label.text = ""
