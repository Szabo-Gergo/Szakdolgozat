extends Base_Enemy
class_name TargetDummy

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var flash_timer: Timer = $FlashTimer
var base_position : Vector2

func _ready() -> void:
	player = get_tree().get_root().find_child("Player", true, false)
	base_position = global_position
	
	
func _process(delta: float) -> void:
	if global_position != base_position or health_component.stat_sheet.max_health != health_component.health:
		$Reset.start()


func _on_reset_timeout() -> void:
	global_position = base_position
	health_component.healing(health_component.stat_sheet.max_health - health_component.health)
	
