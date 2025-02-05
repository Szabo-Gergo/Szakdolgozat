extends Panel

@export var health_component : Health_Component
var health_point = preload("res://Scenes/Misc/health_bar_point.tscn")
@onready var grid_container: GridContainer = $GridContainer
@onready var health_bar: Panel = $"."

func _ready() -> void:
	health_setup()

func health_setup():
	update_health_bar()
	for i in range(0, health_component.stat_sheet.max_health):
		var p = health_point.instantiate()
		p.color = "ca0019"
		grid_container.add_child(p)
	
	for i in range(0, health_component.stat_sheet.max_armor):
		var p = health_point.instantiate()
		p.color = "0600c9"
		grid_container.add_child(p)
	

func update_health_points():
	visible = true
	var grid_points = grid_container.get_children()
	for i in range(grid_points.size()-1, (health_component.health+health_component.armor)-1, -1):
		grid_points[i].queue_free()
	update_health_bar()

func update_health_bar():
	var total_stats : int
	
	if grid_container.get_children().is_empty():
		total_stats = health_component.stat_sheet.max_health + health_component.stat_sheet.max_armor	
	else:
		total_stats = health_component.health + health_component.armor
		
	size.x = 3 + min(total_stats, 10) * 4
	size.y = 3 + ceil(total_stats / 10.0) * 4
	
	if total_stats == 0:
		visible = false
