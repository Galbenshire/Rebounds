extends Node

onready var Player : KinematicBody2D = $Player

func _ready():
	_set_player_camera_bounds()

func _set_player_camera_bounds() -> void:
	var tile_rect = $TileMap.get_used_rect()
	tile_rect.size *= $TileMap.cell_size
	Player.set_camera_bounds(tile_rect)