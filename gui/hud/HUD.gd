extends CanvasLayer

signal sequence_finished()

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
