class_name Zombie
extends Enemy

@onready var vision_shape: CollisionShape2D = $VisionArea/CollisionShape2D
@export var item_rates: Dictionary = {
	"coin": 20,
	"heart": 20
}
func _ready() -> void:
	_init_body()
	dropable = Dropable.new(self, item_rates)
	animation_tree = $AnimationTree
	animation_tree.active = true
	
	navigation_agent = $NavigationAgent2D
	
	level = randi_range(1,2)
	var range_start = 1+(level-1)*2
	var range_end = 5+(level-1)*2
	health = randi_range(range_start, range_end)
	vision_shape.shape.radius =  180 * level
	is_smart = true
