class_name Coin
extends Item

var points: int

func _ready() -> void:
	super._ready()
	anim_sprite = $AnimatedSprite2D
	points  = randi_range(1,5)
	
func collect_item(player: Player) -> bool:
	if player.has_method("add_coins"):
		player.add_coins(points)
	return super.collect_item(player)
