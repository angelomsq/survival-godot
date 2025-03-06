extends CanvasLayer

@onready var main_title_label: Label = $Control/Panel/MainTitleLabel
@onready var score_label: Label = $Control/Panel/ScoreLabel
@onready var time_label: Label = $Control/Panel/TimeDisplay/TimeLabel
@onready var coins_label: Label = $Control/Panel/CoinsDisplay/CoinsLabel
@onready var kills_label: Label = $Control/Panel/KillsDisplay/KillsLabel
var player: Player

func _ready() -> void:
	player = PlayerManager.player

func _process(delta: float) -> void:
	pass

func _start_game_over(display: bool) -> void:
	self.update_info()
	self.visible = display
	if not display:
		PlayerManager.time_start += Time.get_unix_time_from_system() - PlayerManager.time_now

func _on_restart_button_pressed() -> void:
	PlayerManager.current_scene.pause_game()
	get_tree().reload_current_scene()

func _on_back_button_pressed() -> void:
	PlayerManager.current_scene.pause_game()
	get_tree().change_scene_to_file("res://scenes/title_screen.tscn")

func _on_share_button_pressed() -> void:
	pass # Replace with function body.

func update_info() -> void:
	if player.health > 0:
		main_title_label.text = 'Paused'
	else:
		main_title_label.text = 'Game Over'
	score_label.text = str(player.score)
	coins_label.text = str(player.coins)
	kills_label.text = str(player.kills)
	time_label.text = PlayerManager.get_time_localized()
