extends ProgressBar

@export var health_component : Health_Component
@onready var shield_bar: ProgressBar = $ShieldBar
@onready var damage_bar: ProgressBar = $DamageBar
@onready var health_bar: ProgressBar = $"."
@onready var damage_timer: Timer = $Damage_Timer
@onready var visibility_timer: Timer = $Visibility_Timer

func _ready() -> void:
	health_setup()
	
func health_setup():
	var max_value = health_component.health+health_component.armor
	health_bar.max_value = max_value
	shield_bar.max_value = max_value
	damage_bar.max_value = max_value

	health_bar.value = health_component.health
	shield_bar.value = shield_bar.max_value
	damage_bar.value = damage_bar.max_value
	

func update_health_points():
	health_bar.value = health_component.health
	shield_bar.value = health_component.health+health_component.armor
	damage_timer.start()
	visible = true
	visibility_timer.start()


func _on_damage_timer_timeout() -> void:
	damage_bar.value = health_component.health+health_component.armor


func _on_visibility_timer_timeout() -> void:
	visible = false
