class_name Player 
extends Character

var roll_speed: float = 180.0
var roll_timer: float = 1.0
var can_roll: bool = true
var coins := 0
var score := 0
var kills := 0
var invincible: bool = false

func _ready() -> void:
	animated_sprite.material = SHADER_EFFECT.duplicate()
	PlayerManager.player = self
	add_to_group("player")
	animation_tree = $AnimationTree
	animation_tree.active = true
	damaged_timer = 1.0
	speed = 80.0
	health = 10
	max_health = 10
	score = 0

func _physics_process(delta: float) -> void:
	match state:
		States.IDLE, States.WALK:
			move_state(delta)
		States.ROLL:
			roll_state(delta)
		States.ATTACK, States.ATTACK2:
			attack_state(delta)
		States.DEAD:
			dead_state(delta)
	#print(state)
	handle_action_area(delta)
	move_and_slide()
	animate()

func _input_vector_direction() -> Vector2:
	var input_vector = Input.get_vector("move_left","move_right","move_up","move_down")
	if input_vector != Vector2.ZERO:
		direction = input_vector
	
	return input_vector

func _input_action_roll() -> void:
	if Input.is_action_just_pressed("roll") and can_roll:
		change_state(States.ROLL)

func move_state(delta) -> void:
	var input_vector = _input_vector_direction()
	if input_vector == Vector2.ZERO:
		change_state(States.IDLE)
		stop_move()
	else:
		change_state(States.WALK)
		move(input_vector)

	_input_action_roll()
	
	if Input.is_action_just_pressed("attack"):
		change_state(States.ATTACK)
		
func roll_state(delta):
	set_invincibility(true)
	velocity = direction * roll_speed
	# Roll Timer Start
	can_roll = false
	await get_tree().create_timer(roll_timer).timeout
	can_roll = true
	# Roll Timer End

func attack_state(delta):
	velocity *= 0.5
	
	_input_action_roll()
	
	if Input.is_action_just_pressed("attack"):
		print("2nd attack")
		
		_input_vector_direction()
			
		var playback = animation_tree["parameters/playback"]
		var attack_anim_time = playback.get_current_play_position()
		var attack_anim_length =playback.get_current_length()
		if attack_anim_time >= attack_anim_length / 2:
			match state:
				States.ATTACK:
					change_state(States.ATTACK2)
				States.ATTACK2:
					change_state(States.ATTACK)

func dead_state(delta):
	set_invincibility(true)
	stop_move()
	animated_sprite.material.set_shader_parameter('intensity', 0.0)

func _on_attack_animation_finish() -> void:
	change_state(States.IDLE)

func _on_roll_animation_finish() -> void:
	set_invincibility(false)
	change_state(States.IDLE)

func _on_death_animation_finished() -> void:
	print("PLAYER DIE!")
	PlayerManager.current_scene.pause_game()

func set_invincibility(status: bool) -> void:
	$HurtBox.set_deferred("monitoring", !status)
	self.invincible = status

func take_damage(amount) -> void:
	if invincible: return
	super.take_damage(amount)
	PlayerManager.hud.update_health()

func damage_shader() -> void:
	set_invincibility(true)
	await super.damage_shader()
	if health > 0:
		set_invincibility(false)

func add_health(amount: int) -> void:
	if health + amount > max_health:
		health = max_health
	else:
		health += amount
	PlayerManager.hud.update_health()

func add_max_health() -> void:
	max_health += 2
	health = max_health
	PlayerManager.hud.update_max_health(2)
	PlayerManager.hud.update_health()
	
func add_coins(amount: int) -> void:
	coins += amount
	PlayerManager.hud.update_coins()
	
func add_score(factor: int) -> void:
	var random_point = randi_range(1,20)
	score += factor * random_point
	PlayerManager.hud.update_score()

func is_dead() -> bool:
	return state == States.DEAD
