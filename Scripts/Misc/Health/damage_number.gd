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
		
	if get_child(0):
		label = get_child(0)
		label.text = str(int(label.text) + damage)
	else:
		add_child(label)
		start_animation()
	

func start_animation():
	var anim = get_tree().create_tween()
	label.position = position
	anim.tween_property(label, "position:y", label.position.y - label.size.y*2, 1).set_ease(Tween.EASE_IN)
