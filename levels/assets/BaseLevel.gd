extends Node
"""
A base scene for all levels to inherit from,
containing data and functions common to every level.

NOTES:
	- It is important that the size of MainTileMap isn't smaller than the size of the screen
	- The upperleft corner of MainTileMap should be at origin (0,0)
"""

onready var Player : KinematicBody2D = $Playfield/Player
onready var HUD : CanvasLayer = $HUD

func _ready() -> void:
	_setup()
	_start_level()

func _setup() -> void:
	_set_player_camera_bounds()
	_connect_enemies_to_navigation()
	Player.set_control_state(false)

func _start_level() -> void:
	HUD.do_ready_sequence()
	yield(HUD, "sequence_finished")
	Player.set_control_state(true)

func _end_level() -> void:
	Player.set_control_state(false)
	HUD.do_level_clear_sequence()
	yield(HUD, "sequence_finished")
	
	#Do this for now
	get_tree().reload_current_scene()

func _set_player_camera_bounds() -> void:
	var total_tilemap_rect = _get_total_tilemap_size()
	Player.set_camera_bounds(total_tilemap_rect)

func _get_total_tilemap_size() -> Rect2:
	var tile_rect = $Playfield/NavigationTiles/MainTileMap.get_used_rect()
	tile_rect.size *= $Playfield/NavigationTiles/MainTileMap.cell_size
	
	assert(tile_rect.size >= get_viewport().get_visible_rect().size)
	
	return tile_rect

func _connect_enemies_to_navigation() -> void:
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.connect("nav_path_requested", self, "_give_enemy_nav_path")

func _give_enemy_nav_path(enemy : Area2D) -> void:
	print(enemy, " requested a nav path")
	var new_path = $Playfield/NavigationTiles.get_simple_path(enemy.position, enemy.get_target_location())
	enemy.path = new_path

func _on_FinishPoint_player_reached_end() -> void:
	_end_level()
