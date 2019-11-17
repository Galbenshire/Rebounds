extends Resource
class_name PlayerData

signal score_changed()

export (int, 1, 255) var max_life : int setget set_max_life

var score : int = 0
var life : int setget set_life

func set_max_life(value : int) -> void:
	max_life = value
	set_life(max_life)

func set_life(value : int) -> void:
	life = value
	emit_signal("score_changed")

func reset_life() -> void:
	set_life(max_life)