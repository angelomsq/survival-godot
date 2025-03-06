extends GameLevel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	navigation_tilemap = $LowerGround
	y_sort_layer = $"Y-SortLayer"


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
