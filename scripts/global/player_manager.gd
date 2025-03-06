extends Node

var player: Player
var hud: GameHUD
var current_scene: GameLevel
var time_start = 0
var time_now = 0
var is_paused := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func get_time_localized() -> String:
	var dif = time_now - time_start
	var minutes = int(dif / 60 )
	var seconds = int(dif) % 60
	return ("%02d" % minutes) + (":%02d" % seconds)

func get_pad_score() -> String:
	return ("%08d" % player.score)

func get_pad_coins() -> String:
	return ("%08d" % player.coins)

func get_pad_kills() -> String:
	return ("%08d" % player.kills)
