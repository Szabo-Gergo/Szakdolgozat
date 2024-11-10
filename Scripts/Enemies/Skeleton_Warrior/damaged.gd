extends State
class_name Basic_Enemy_Damaged


@onready var player: CharacterBody2D = get_node("/root/Main/Player")
@onready var animation_tree: AnimationTree = $"../../AnimationTree"
@onready var skeleton_sprite: Sprite2D = $"../../Skeleton_Sprite"
@onready var state_label: Label = $"../../StateLabel"
@onready var skeleton: Base_Enemy = $"../.."

@onready var hit_particle: GPUParticles2D = $"../../Hit_Particle"

var state_origin : String
var base_damage : int
var damaged_again : bool

func enter(_inputs : Dictionary = {}):
	damaged_again = true
	state_origin = _inputs["state_origin"]
	base_damage = _inputs["damage"]
	deal_damage(base_damage)
	
func deal_damage(damage):
	skeleton._add_health(-damage)
	state_label.text = "HP "+str(skeleton.health)
	flash(0.2)


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Damaged":
		damaged_again = false
		if state_origin == "Move":
			transition.emit(self, state_origin)
		else:
			var direction = skeleton.global_position.direction_to(Vector2i(player.position))
			transition.emit(self, state_origin, {"direction" : direction})
		
		
func check_health():
	if skeleton.health == 0: 
		transition.emit(self, "Death")


#If damaged while in the same state reset animation and check collision
func _on_hurt_box_area_entered(area: Area2D) -> void:
	if damaged_again:
		animation_tree.set("active", false)
		animation_tree.set("active", true)

		if area.is_in_group("Player_Melee_HitBox"):
				deal_damage(player.get("base_stats")._get_damage())
		elif area.is_in_group("Player_Projectile_HitBox"):
				deal_damage(player.get("projectile_damage"))


func flash(time):
	skeleton_sprite.material.set("shader_parameter/flash_opacity", 1)
	await get_tree().create_timer(time).timeout
	skeleton_sprite.material.set("shader_parameter/flash_opacity", 0)
