class_name HurtBox
extends Area2D

@export var resistence := 10

func _init() -> void:
	collision_layer = 2
	collision_mask = 4 | 16 # HitBoxes Layer and Moving Floor

func _ready() -> void:
	self.connect("area_entered", _on_area_entered)
	
func _on_area_entered(hitbox: HitBox) -> void:
	print("hitbox owner: ", hitbox.owner)
	if hitbox == null or owner.is_in_group(hitbox.owner.get_groups()[0]):
		return

	if owner.has_method("take_damage"):
		owner.take_damage(hitbox.damage)
	if owner.has_method("knockback") and hitbox.impact > 0:
		var knock_force = hitbox.impact - self.resistence
		owner.knockback(hitbox.owner.direction, knock_force)
	if owner.has_method("damage_shader"):
		owner.damage_shader()
	
	if hitbox.owner.has_method("add_score"):
		hitbox.owner.add_score(1) # TODO: Calculate Score based on the Hurtbox Owner
