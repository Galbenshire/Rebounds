extends CanvasLayer

signal sequence_finished()

const PlayerData := preload("res://scriptable_objects/PlayerData.tres")

func _ready() -> void:
	PlayerData.connect("values_changed", self, "update_banner")
	update_banner()

func do_ready_sequence() -> void:
	$Wrapper/Ready.show()
	yield(get_tree().create_timer(2.0), "timeout")
	$Wrapper/Ready.hide()
	emit_signal("sequence_finished")

func do_level_clear_sequence() -> void:
	$Wrapper/LevelClear.show()
	yield(get_tree().create_timer(2.0), "timeout")
	$Wrapper/LevelClear.hide()
	emit_signal("sequence_finished")

func do_game_over_sequence() -> void:
	$Wrapper/GameOver.show()
	yield(get_tree().create_timer(2.0), "timeout")
	$Wrapper/GameOver.hide()
	emit_signal("sequence_finished")

func update_banner() -> void:
	$Wrapper/Banner/Life.text = str("LIFE - %d" % PlayerData.life)
	$Wrapper/Banner/Score.text = str("SCORE - %d" % PlayerData.score)