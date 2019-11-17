extends CanvasLayer

signal sequence_finished()

const PlayerData := preload("res://scriptable_objects/PlayerData.tres")

func _ready() -> void:
	PlayerData.connect("score_changed", self, "update_banner")
	update_banner()

func do_ready_sequence() -> void:
	$Ready.show()
	yield(get_tree().create_timer(2.0), "timeout")
	$Ready.hide()
	emit_signal("sequence_finished")

func do_level_clear_sequence() -> void:
	$LevelClear.show()
	yield(get_tree().create_timer(2.0), "timeout")
	$LevelClear.hide()
	emit_signal("sequence_finished")

func do_game_over_sequence() -> void:
	$GameOver.show()
	yield(get_tree().create_timer(2.0), "timeout")
	$GameOver.hide()
	emit_signal("sequence_finished")

func update_banner() -> void:
	$Banner/Life.text = str("Life - %d" % PlayerData.life)