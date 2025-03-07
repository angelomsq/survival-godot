class_name Dropable
extends Object
#Items
const COIN = preload("res://scenes/misc/coin.tscn")
const HEART = preload("res://scenes/misc/heart.tscn")
const ITEMS = {
	"coin": COIN,
	"heart": HEART
}

var rates: Dictionary
var owner: Node2D
var drop_types: Array[Dictionary]

func _init(_owner: Node2D, _rates = { "coin": 50, "heart": 10 }) -> void:
	owner = _owner
	rates = _rates
	_set_drop_types()
	print(drop_types)

func _set_drop_types() -> void:
	var items = ITEMS.keys()
	var count = 0
	for item in items:
		if rates.has(item) and rates[item] > 0:
			drop_types.append({
				"name": item,
				"drops": ITEMS[item],
				"rate": [ count+1, count + rates[item] ]
			})
			count += rates[item]
	if count < 100:
		drop_types.append({
			"name": "none",
			"drops": null,
			"rate": [count+1, 100]
		})
	
func _get_random_drop() -> Dictionary:
	var random_percent = randi_range(1,100)
	var random_type = drop_types.filter(func(item): return random_percent >= item.rate[0] and random_percent <= item.rate[1])[0]
	return random_type
	
func drop_item() -> void:
	var new_drop: Item
	var item = _get_random_drop()
	if not item.drops:
		return
	
	new_drop = item.drops.instantiate()
	owner.get_parent().add_child(new_drop)
	new_drop.global_position = owner.global_position
