extends PermenantProjectileStatStrategy
class_name TemporaryProjectileStatStrategy

@export var duration: float

func apply_stat(target: Node, is_remove : bool = false):
	super.apply_stat(target)
	var timer = target.get_tree().create_timer(duration)
	timer.timeout.connect(func():
		super.apply_stat(target, true)
	)


func _to_string() -> String:
	var output = ""
	output = super._to_string()
	output += "for %d seconds" % duration
	return output
