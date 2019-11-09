extends Node
"""
A base scene for all levels to inherit from,
containing data and functions common to every level.

NOTES:
	- It is important that the size of MainTileMap isn't smaller than the size of the screen
	- The upperleft corner of MainTileMap should be at origin (0,0)
"""

onready var Player : KinematicBody2D = $Playfield/Player

func _ready() -> void:
	_set_player_camera_bounds()

func _start_level() -> void:
	pass

func _end_level() -> void:
	pass

func _set_player_camera_bounds() -> void:
	var total_tilemap_rect = _get_total_tilemap_size()
	Player.set_camera_bounds(total_tilemap_rect)

func _get_total_tilemap_size() -> Rect2:
	var tile_rect = $Playfield/NavigationTiles/MainTileMap.get_used_rect()
	tile_rect.size *= $Playfield/NavigationTiles/MainTileMap.cell_size
	
	assert(tile_rect.size >= get_viewport().get_visible_rect().size)
	
	return tile_rect