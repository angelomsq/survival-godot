class_name GameLevel
extends Node2D
@export var camera: Camera2D
@export var navigation_tilemap: TileMapLayer
@export var y_sort_layer: Node2D
@onready var game_over_screen: CanvasLayer = $GameOverScreen

const GAME_HUD = preload("res://scenes/gui/game_hud.tscn")
var spawn_timer = Timer.new()
const GOBLIN = preload("res://scenes/enemy/goblin.tscn")
const ZOMBIE = preload("res://scenes/enemy/zombie.tscn")
const SKELETON = preload("res://scenes/enemy/skeleton.tscn")

const enemies = [
	GOBLIN,
	ZOMBIE,
	SKELETON
]

func _ready() -> void:
	game_over_screen.visible = false
	PlayerManager.current_scene = self
	var game_hud = GAME_HUD.instantiate()
	add_child(game_hud)
	PlayerManager.hud = game_hud
	
	#Spawn Timer
	spawn_timer.wait_time = 3.0
	add_child(spawn_timer)
	spawn_timer.connect("timeout", _on_spawn_timeout)
	spawn_timer.start()

func _on_spawn_timeout() -> void:
	var rand_amount = randi_range(1,2)
	var rand_enemy = randi_range(0,1)
	var nav_map = navigation_tilemap.get_navigation_map()
	for i in rand_amount:
		var new_enemy = enemies[rand_enemy].instantiate()
		new_enemy.position = NavigationServer2D.map_get_random_point(nav_map, 1, false)
		y_sort_layer.add_child(new_enemy)

func _physics_process(delta: float) -> void:
	if not PlayerManager.player.is_dead():
		if Input.is_action_just_pressed("pause"):
			pause_game()
	
func pause_game() -> void:
	PlayerManager.is_paused = !PlayerManager.is_paused
	game_over_screen._start_game_over(PlayerManager.is_paused)
	get_tree().set_pause(PlayerManager.is_paused)
