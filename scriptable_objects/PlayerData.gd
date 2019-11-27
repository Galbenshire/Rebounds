extends Resource
class_name PlayerData

signal values_changed()

export (int, 1, 255) var max_life : int setget set_max_life

var score : int setget set_score
var life : int setget set_life
var bullets_shot : int
var time_in_level : float
var was_hit : bool = false

func set_max_life(value : int) -> void:
	max_life = value
	set_life(max_life)

func set_score(value : int) -> void:
	score = value
	emit_signal("values_changed")

func set_life(value : int) -> void:
	life = value
	emit_signal("values_changed")

func reset() -> void:
	set_life(max_life)
	set_score(0)
	bullets_shot = 0
	time_in_level = 0.0
	was_hit = false

func reset_life() -> void:
	set_life(max_life)