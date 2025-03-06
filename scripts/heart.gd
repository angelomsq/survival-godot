class_name Heart
extends Item

var points: int
const heart_types = [
	{ "name": "half", "points": 1, "rate": [1, 50] },
	{ "name": "full", "points": 2, "rate": [51, 90] },
	{ "name": "gold", "points": 0, "rate": [91, 100] },
]

func _ready() -> void:
	super._ready()
	anim_sprite = $AnimatedSprite2D
	
	var random_percent = randi_range(1,100)
	var random_type = heart_types.filter(func(item): return random_percent >= item.rate[0] and random_percent <= item.rate[1])[0]
	points = random_type.points
	anim_sprite.play(random_type.name)
	
func collect_item(player: Player) -> bool:
	if points:
		if player.health == player.max_health: return false
		player.add_health(points)
		player.add_score(1)
	else:
		player.add_max_health()
		player.add_score(2)
	return super.collect_item(player)
