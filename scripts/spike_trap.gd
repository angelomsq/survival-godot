class_name SpikeTrap
extends HitBox

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
var trap_timer = Timer.new()

func _ready() -> void:
	trap_timer.wait_time = 2.0
	add_child(trap_timer)
	trap_timer.connect("timeout", _on_trap_timer_timeout)
	trap_timer.start()

func _on_trap_timer_timeout() -> void:
	if not collision_shape.disabled:
		anim_sprite.set_speed_scale(1.0)
		anim_sprite.play_backwards("default")
		await anim_sprite.animation_finished
		collision_shape.disabled = true
	else:
		anim_sprite.set_speed_scale(2)
		anim_sprite.play("default")
		collision_shape.disabled = false
