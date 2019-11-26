extends ColorRect

signal finished()

func start() -> void:
	$AnimationPlayer.play("sequence")

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	emit_signal("finished")
