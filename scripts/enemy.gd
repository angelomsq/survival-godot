class_name Enemy
extends Character

var dropable = Dropable.new(self)
var target: Node2D = null
var vision_area: VisionArea
var navigation_agent: NavigationAgent2D
var is_smart := false

const SMOKE_EFFECT = preload("res://scenes/effects/smoke_effect.tscn")

func _physics_process(delta) -> void:
	match state:
		States.IDLE, States.WALK:
			if is_smart:
				smart_follow()
			else:
				basic_follow()
		States.DEAD:
			self.die()
			return
	handle_action_area(delta)
	move_and_slide()
	animate()
		
func die() -> void:
	print("ENEMY DIE")
	PlayerManager.player.kills += 1
	PlayerManager.hud.update_kills()
	queue_free()
	create_smoke_effect()
	dropable.drop_item()

func create_smoke_effect() -> void:
	var smoke_effect = SMOKE_EFFECT.instantiate()
	get_parent().add_child(smoke_effect)
	smoke_effect.global_position = global_position

func basic_follow() -> void:
	if !target:
		change_state(States.IDLE)
		direction = Vector2.DOWN
		stop_move()
	else:
		direction = target.global_position - global_position
		if direction.length() >= 2:
			change_state(States.WALK)
			move(direction)
		else:
			change_state(States.IDLE)
			stop_move()

func smart_follow() -> void:
	if target:
		change_state(States.WALK)
		navigation_agent.target_position = target.global_position
	
	if navigation_agent.is_navigation_finished():
		change_state(States.IDLE)
		direction = Vector2.DOWN
		stop_move()
		return
	
	direction = to_local(navigation_agent.get_next_path_position())
	move(direction)

func _init_body() -> void:
	animated_sprite.material = SHADER_EFFECT.duplicate()
	add_to_group("enemy")
	set_motion_mode(CharacterBody2D.MOTION_MODE_FLOATING)
	set_wall_min_slide_angle(deg_to_rad(0.4))
	collision_layer = 4
	collision_mask = 1 | 2
	
