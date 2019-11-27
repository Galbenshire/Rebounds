extends CanvasLayer

signal sequence_finished()

func _ready() -> void:
	pass

func do_ready_sequence() -> void:
	$Wrapper/ReadyUI.start()
	yield($Wrapper/ReadyUI, "finished")
	$Wrapper/ReadyUI.hide()
	emit_signal("sequence_finished")

func do_level_clear_sequence() -> void:
	$Wrapper/LevelClearUI.start()
	yield($Wrapper/LevelClearUI, "finished")
	emit_signal("sequence_finished")

func do_game_over_sequence() -> void:
	$Wrapper/GameOver.show()
	yield(get_tree().create_timer(2.0), "timeout")
	$Wrapper/GameOver.hide()
	emit_signal("sequence_finished")
