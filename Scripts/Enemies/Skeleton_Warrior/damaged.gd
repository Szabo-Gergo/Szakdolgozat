extends State

@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var skeleton: CharacterBody2D = $"../.."
@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var skeleton_sprite: Sprite2D = $"../../Skeleton_Sprite"

var playback
var stats : BaseStats
var state_origin : String
var damage : int
var damaged_again : bool

func enter(_inputs : Dictionary = {}):
	damaged_again = true
	stats = skeleton.get("base_stats")
	stats.connect("entity_died", _enemy_died)
	state_origin = _inputs["state_origin"]
	damage = _inputs["damage"]
	deal_damage()

func exit():
	damaged_again = false
	
func _enemy_died():
	print("DIED")
	transition.emit(self, "Death")
	
func deal_damage():
	stats._add_health(-damage)
	print("Skeleton health: "+str(stats._get_health()))

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Damaged" and stats._get_health() > 0:
		if state_origin == "Move":
			transition.emit(self, state_origin)
		else:
			var direction = skeleton.global_position.direction_to(Vector2i(player.position))
			transition.emit(self, state_origin, {"direction" : direction})
	else:
		_enemy_died()
		
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if area.name == "HitBox" and damaged_again:
		animation_tree.set("active", false)
		animation_tree.set("active", true)
		deal_damage()
