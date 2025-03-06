class_name GameHUD
extends CanvasLayer

var hearts: Array[HeartGUI] = []
var player: Player
@onready var heart_container: HFlowContainer = $Control/HFlowContainer
const HEART_GUI = preload("res://scenes/gui/heart_gui.tscn")
var max_hearts: int
@onready var coins_label: Label = $Control/VFlowContainer/CoinsDisplay/CoinsLabel
@onready var kills_label: Label = $Control/VFlowContainer/KillsDisplay/KillsLabel
@onready var score_label: Label = $Control/ScoreLabel

func _start_hud() -> void:
	process_mode = Node.PROCESS_MODE_PAUSABLE
	player = PlayerManager.player
	_clean_heart_container()
	_set_max_hearts()
	update_coins()
	update_score()
	update_kills()

func _ready() -> void:
	_start_hud()
	for i in max_hearts:
		update_max_health(clampi(player.health - i * 2, 0, 2))

func update_health() -> void:
	for i in max_hearts:
		update_heart(i, player.health)

func update_heart(_index: int, _health: int) -> void:
	var new_value = clampi(_health - _index * 2, 0, 2)
	var old_value = hearts[_index].value
	if old_value == new_value: return
	
	if old_value > new_value:
		hearts[_index].reverse = false
	else:
		hearts[_index].reverse = true
	hearts[_index].change_value(new_value)

func update_max_health(points: int) -> void:
	var new_heart = HEART_GUI.instantiate()
	new_heart.value = points
	heart_container.add_child(new_heart)
	hearts.append(new_heart)
	_set_max_hearts()

func _clean_heart_container() -> void:
	for child in heart_container.get_children():
		heart_container.remove_child(child)
		child.queue_free()

func _set_max_hearts() -> void:
	max_hearts = player.max_health / 2
		
func update_coins() -> void:
	coins_label.text = PlayerManager.get_pad_coins()

func update_score() -> void:
	score_label.text = PlayerManager.get_pad_score()
	
func update_kills() -> void:
	kills_label.text = PlayerManager.get_pad_kills()
