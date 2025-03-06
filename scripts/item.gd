class_name Item
extends Area2D

var binded_to: Player
var anim_sprite: AnimatedSprite2D

func _init() -> void:
	collision_layer = 8
	collision_mask = 2

func _ready() -> void:
	self.connect("area_entered", _on_item_area_entered)

func _on_item_area_entered(hurtbox: HurtBox) -> void:
	print("item_area_entered")
	if hurtbox == null or hurtbox.owner is not Player:
		return
	if collect_item(hurtbox.owner):
		binded_to = hurtbox.owner
		if "collect" in anim_sprite.sprite_frames.get_animation_names():
			collect_animation()
		else:
			collect_effect()

func _physics_process(delta: float) -> void:
	if not binded_to:
		return
		
	global_position = binded_to.global_position + Vector2(0,-8)
	z_index = 99
	
func collect_item(_player: Player) -> bool:
	_player.add_score(1)
	return true

func collect_animation() -> void:
	var effect = create_tween()
	effect.tween_property(self.anim_sprite, "offset:y", -12, 0.2)
	await effect.finished
	anim_sprite.play("collect")
	await anim_sprite.animation_finished
	queue_free()

func collect_effect() -> void:
	var effect = create_tween()
	effect.tween_property(self.anim_sprite, "offset:y", -12, 0.2)
	effect.parallel().tween_property(self, "modulate:a", 0.5, 0.4)
	effect.tween_callback(self.queue_free)
