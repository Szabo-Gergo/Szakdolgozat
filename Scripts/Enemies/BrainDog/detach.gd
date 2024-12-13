extends State

@export var root : CharacterBody2D

func enter(_inputs : Dictionary = {}):
	root.attach_break = 0
	var tween = get_tree().create_tween()
	var rng = RandomNumberGenerator.new()
	
	var rand : int = rng.randi_range(-40,40)

	tween.tween_property(root, "position:y", root.position.y - 20, 0.2).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(root, "position:x", root.position.x + rand, 0.5).set_ease(Tween.EASE_OUT)
	
	tween.tween_property(root, "position:y", root.position.y + 40, 0.5).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(root, "position:x", root.position.x + rand, 0.5).set_ease(Tween.EASE_OUT)
	
	await tween.finished
	transition.emit(self, "Move")
	
