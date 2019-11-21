extends Label

var can_pause : bool = false

func _input(event : InputEvent) -> void:
	if can_pause and event.is_action_pressed("pause"):
		get_tree().paused = !get_tree().paused
		visible = get_tree().paused
		accept_event()