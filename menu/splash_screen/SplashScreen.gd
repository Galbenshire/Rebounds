extends ColorRect

#Needs to be an export so the AnimationPlayer can recognize it
export (bool) var is_skippable : bool = false

func _input(event : InputEvent) -> void:
	if !is_skippable:
		return
	
	var can_skip := false
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		can_skip = true
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_cancel"):
		can_skip = true
	if can_skip:
		_go_to_main_menu()
		accept_event()

func _go_to_main_menu() -> void:
	get_tree().change_scene("res://menu/main_menu/MainMenu.tscn")

func _on_AnimationPlayer_animation_finished(anim_name : String) -> void:
	_go_to_main_menu()
