class_name Character
extends CharacterBody2D
var speed: float = 40.0
var damage := 1
var level := 1
var health: int
var max_health: int
var direction: Vector2 = Vector2.DOWN
var animation_tree: AnimationTree
var damaged_timer := 0.50
var action_area: Array[Node2D]

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
const SHADER_EFFECT = preload("res://scenes/effects/shader_effect.tres")

enum States {
	IDLE,
	WALK,
	ROLL,
	ATTACK,
	ATTACK2,
	HURT,
	DEAD
}
var state = States.IDLE

var direction_pos_paths = {
	States.IDLE: "parameters/Idle/idle_bs2d/blend_position",
	States.WALK: "parameters/Walk/walk_bs2d/blend_position",
	States.ROLL: "parameters/Roll/roll_bs2d/blend_position",
	States.ATTACK: "parameters/Attack/attack_bs2d/blend_position",
	States.ATTACK2: "parameters/Attack2/attack2_bs2d/blend_position",
	States.HURT: "parameters/Hurt/hurt_bs2d/blend_position",
	States.DEAD: "parameters/Dead/dead_bs2d/blend_position"
}

var state_names = {
	States.IDLE: "Idle",
	States.WALK: "Walk",
	States.ROLL: "Roll",
	States.ATTACK: "Attack",
	States.ATTACK2: "Attack2",
	States.HURT: "Hurt",
	States.DEAD: "Dead"
}

func _init() -> void:
	collision_layer = 32
	collision_mask = 1

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass

func change_state(new_state: States) -> void:
	state = new_state

func move(amount) -> void:
	velocity = amount.normalized() * speed

func stop_move() -> void:
	velocity = Vector2.ZERO

func take_damage(amount) -> void:
	#print(self.name, ' / health: ', self.health)
	#print(self.name, ' / state: ', self.state)
	health -= amount
	change_state(States.HURT)
		
func die() -> void:
	pass
	
func animate() -> void:
	animation_tree.set(direction_pos_paths[state], direction)
	animation_tree["parameters/playback"].travel(state_names[state])

func knockback(knock_direction: Vector2, amount := 80) -> void:
	if amount > 0:
		velocity = knock_direction.normalized() * amount

func damage_shader() -> void:
	# Damage/Flash Shader Start
	animated_sprite.material.set_shader_parameter('intensity', 1.0)
	await get_tree().create_timer(damaged_timer).timeout
	animated_sprite.material.set_shader_parameter('intensity', 0.0)
	# Damage/Flash Shader End

func _on_hurt_animation_finish() -> void:
	print(self.name, ' / hurt animation finish')
	if health <= 0:
		change_state(States.DEAD)
	else:
		change_state(States.IDLE)

func handle_action_area(delta: float) -> void:
	if action_area.size():
		var action_node = action_area[0]
		position += action_node.direction.normalized() * action_node.speed * delta
