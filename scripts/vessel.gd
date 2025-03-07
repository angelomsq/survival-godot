class_name Vessel
extends StaticBody2D
@onready var anim_sprite: AnimatedSprite2D = $AnimatedSprite2D

var health := 1
@export var item_rates: Dictionary = {
	"coin": 30,
	"heart": 5
}
var dropable = Dropable.new(self, item_rates)

func _ready() -> void:
	add_to_group("enemy")

func _process(delta: float) -> void:
	pass

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		_destroy()
		
func _destroy() -> void:
	anim_sprite.play("destroy")
	await anim_sprite.animation_finished
	queue_free()
	dropable.drop_item()
	
