class_name MovingFloor
extends Area2D

enum DirType {
	DOWN = 0,
	LEFT = 1,
	RIGHT = 2,
	UP = 3,
}

@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D
@export var type: DirType
var direction: Vector2
var speed := 30

func _init() -> void:
	collision_layer = 16
	collision_mask = 32 # Character Body Layer

func _ready() -> void:
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)
	match type:
		DirType.DOWN:
			anim_sprite.play("down")
			direction = Vector2.DOWN
		DirType.LEFT:
			anim_sprite.play("left")
			direction = Vector2.LEFT
		DirType.RIGHT:
			anim_sprite.play("right")
			direction = Vector2.RIGHT
		DirType.UP:
			anim_sprite.play("up")
			direction = Vector2.UP

func _on_body_entered(body: Character) -> void:
	body.action_area.append(self)

func _on_body_exited(body: Character) -> void:
	body.action_area.erase(self)
