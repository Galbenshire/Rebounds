"""
This is the scene that represents the player.
It has twin stick shooter controls; moving & aiming are independent of each other.

There is support for both controllers & keyboard/mouse.
Depending on which is used, the code will adjust accordingly.
"""
extends KinematicBody2D

onready var PlayerSprite : Sprite = $Sprite

const STICK_DEADZONE := 0.3

export (float) var move_speed := 90.0

var _mouse_mode : bool = false

func _unhandled_input(event : InputEvent) -> void:
	if _mouse_mode and _is_gamepad_used(event):
		_mouse_mode = false
	elif !_mouse_mode and _is_keyboard_used(event):
		_mouse_mode = true

func _physics_process(delta : float) -> void:
	_player_movement()
	_player_aiming()

func set_camera_bounds(bounds : Rect2) -> void:
	$Camera.limit_left = bounds.position.x
	$Camera.limit_top = bounds.position.y
	$Camera.limit_right = bounds.end.x
	$Camera.limit_bottom = bounds.end.y

func _is_gamepad_used(event : InputEvent) -> bool:
	if event is InputEventJoypadButton:
		return true
	if event is InputEventJoypadMotion and abs(event.axis_value) > STICK_DEADZONE:
		return true
	return false

func _is_keyboard_used(event : InputEvent) -> bool:
	if event is InputEventKey:
		return true
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT:
		return true
	return false

func _player_movement() -> void:
	var input_direction := Vector2(Input.get_action_strength("player_right") - Input.get_action_strength("player_left"),
			Input.get_action_strength("player_down") - Input.get_action_strength("player_up")).normalized()
	# If I don't need 'delta' for move_and_slide, no point bringing it into 'player_movement()'
	move_and_slide(input_direction * move_speed)

func _player_aiming() -> void:
	if _mouse_mode:
		PlayerSprite.look_at(get_global_mouse_position())
	else:
		# Not really worth making 4 whole input actions just for this single occurance.
		var right_stick_direction := Vector2(Input.get_joy_axis(0, JOY_AXIS_2), Input.get_joy_axis(0, JOY_AXIS_3))
		if right_stick_direction.length() > STICK_DEADZONE:
			right_stick_direction = right_stick_direction.normalized()
			PlayerSprite.rotation = right_stick_direction.angle()