extends Resource
class_name PlayerData

signal values_changed()

export (int, 1, 255) var max_life : int setget set_max_life

var score : int setget set_score
var life : int setget set_life

func set_max_life(value : int) -> void:
	max_life = value
	set_life(max_life)

func set_score(value : int) -> void:
	score = value
	emit_signal("values_changed")

func set_life(value : int) -> void:
	life = value
	emit_signal("values_changed")

func reset_life() -> void:
	set_life(max_life)