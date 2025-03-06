extends HitBox

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
var direction: Vector2
var speed := 60
var is_active := true

func _ready() -> void:
	collision_mask = 1 | 2
	self.connect("area_entered", _on_area_entered)
	self.connect("body_entered", _on_body_entered)

func _on_area_entered(hurtbox: HurtBox) -> void:
	_destroy()

func _on_body_entered(body) -> void:
	if self.owner == body:
		return 
	_destroy()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_active:
		position += direction.normalized() * speed * delta

func _setup(_owner: Node2D) -> void:
	set_owner(_owner)
	direction = owner.direction
	global_position = global_position + (direction.normalized() * 8)
	rotation_degrees = owner.angle

func _destroy() -> void:
	is_active = false
	anim_sprite.play("collide")
	await anim_sprite.animation_finished
	queue_free()
