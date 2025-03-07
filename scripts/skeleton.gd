class_name Skeleton
extends Enemy

@onready var vision_shape: CollisionShape2D = $VisionArea/CollisionShape2D
@export var item_rates: Dictionary = {
	"coin": 20,
	"heart": 40
}

func _ready() -> void:
	_init_body()
	dropable = Dropable.new(self, item_rates)
	animation_tree = $AnimationTree
	animation_tree.active = true
	
	navigation_agent = $NavigationAgent2D
	
	_set_stats()
	#level = randi_range(1,2)
	#var range_start = 1+(level-1)*2
	#var range_end = 5+(level-1)*2
	#health = randi_range(range_start, range_end)
	
	vision_shape.shape.radius =  180 * level
	is_smart = true


func _set_stats() -> void:
	level = 2
	speed = 70
	health = 5
