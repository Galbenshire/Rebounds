extends ColorRect

signal finished()

const PlayerData := preload("res://scriptable_objects/PlayerData.tres")

func start() -> void:
	$AnimationPlayer.play("sequence")

func grab_values() -> void:
	$Score.text = str("SCORE - %d" % PlayerData.score)
	$Bullets.text = str("BULLETS SHOT - %d" % PlayerData.bullets_shot)
	$Time.text = str("TIME - %.2f" % PlayerData.time_in_level)

func evaluate_no_hit_run() -> void:
	if !PlayerData.was_hit:
		$NoHit.show()

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	emit_signal("finished")
