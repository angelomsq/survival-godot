class_name ShootingTrap
extends StaticBody2D

enum DirType {
	DOWN = 0,
	LEFT = 1,
	RIGHT = 2,
	UP = 3,
}

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var type: DirType
var direction: Vector2
var angle: int
var shoot_timer = Timer.new()
const FIREBALL = preload("res://scenes/misc/fireball.tscn")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_to_group("traps")
	match type:
		DirType.DOWN:
			anim_sprite.play("down")
			direction = Vector2.DOWN
			angle = 0
		DirType.LEFT:
			anim_sprite.play("left")
			direction = Vector2.LEFT
			angle = 90
		DirType.RIGHT:
			anim_sprite.play("right")
			direction = Vector2.RIGHT
			angle = -90
		DirType.UP:
			anim_sprite.play("up")
			direction = Vector2.UP
			angle = 180
			
	shoot_timer.wait_time = 2.0
	add_child(shoot_timer)
	shoot_timer.connect("timeout", _on_shoot_timer_timeout)
	shoot_timer.start()


func _on_shoot_timer_timeout() -> void:
	var new_fireball = FIREBALL.instantiate()
	add_child(new_fireball)
	new_fireball._setup(self)
	#new_fireball.set_owner(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
