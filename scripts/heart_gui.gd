class_name HeartGUI
extends Control

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

var	reverse := false
var value_change := false
var value: int = 2

func _ready() -> void:
	match value:
		0:
			animated_sprite.play("add_empty")
		1:
			animated_sprite.play("add_half")
		2:
			animated_sprite.play("add_heart")

func change_value(_value: int) -> void:
	print("VALUE CHANGE")
	value = _value
	value_change = true
	
func animate() -> void:
	if not value_change:
		return
	print("animate value change")
	match value:
		0:
			animated_sprite.play("half2empty")
		1:
			if reverse:
				animated_sprite.play_backwards("half2empty")
			else:
				animated_sprite.play("full2half")
		2:
			animated_sprite.play_backwards("full2half")
	
	value_change = false

func _physics_process(delta: float) -> void:
	animate()
