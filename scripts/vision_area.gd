class_name VisionArea
extends Area2D

func _init() -> void:
	collision_layer = 0
	collision_mask = 2 # Hurtboxes Layer
	
func _ready() -> void:
	self.connect("area_entered", _on_vision_area_entered)
	self.connect("area_exited", _on_vision_area_exited)
	
func _on_vision_area_entered(hurtbox: HurtBox) -> void:
	if hurtbox == null or hurtbox.owner is not Player:
		return

	if "target" in owner:
		owner.target = hurtbox

func _on_vision_area_exited(hurtbox: HurtBox) -> void:
	if not owner or hurtbox == null or hurtbox.owner is not Player:
		return
	if "target" in owner:
		owner.target = null
