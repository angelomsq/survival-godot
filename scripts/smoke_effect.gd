extends AnimatedSprite2D

func _ready() -> void:
	animation_finished.connect(_on_animation_finished)
	play("animate")

func _on_animation_finished() -> void:
	queue_free()
