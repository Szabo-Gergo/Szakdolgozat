extends Node2D
class_name DamageNumberComponent

var label_ready : bool
var label : Label
	
func display_damage(damage : int, is_healing : bool):
	label = Label.new()
	
	label.text = str(damage)
	label.label_settings = LabelSettings.new()
	label.label_settings.font_size = 10
	label.position.x = position.x
	label.modulate.a = 1
	
	if is_healing:
		label.label_settings.outline_color = "00ff00";
	else:
		label.label_settings.outline_color = "ff0000";

	label.label_settings.outline_size = 1;
	label.label_settings.font_size = 10
		
	add_child(label)
		
	var anim = get_tree().create_tween()
	var rng = RandomNumberGenerator.new()
	var rand : int = rng.randi_range(-10,10)

	anim.tween_property(label, "position:y", label.position.y - label.size.y*2, 0.2).set_ease(Tween.EASE_IN)
	anim.parallel().tween_property(label, "position:x", label.position.x + rand, 0.5).set_ease(Tween.EASE_OUT)
	
	anim.tween_property(label, "position:y", label.position.y + label.size.y, 0.5).set_ease(Tween.EASE_IN)
	anim.parallel().tween_property(label, "position:x", label.position.x + rand, 0.5).set_ease(Tween.EASE_OUT)

	anim.finished.connect(label.queue_free)
	
