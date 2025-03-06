class_name HitBox
extends Area2D

@export var damage := 1
@export var impact := 40

func _init() -> void:
	collision_layer = 4
	collision_mask = 0
