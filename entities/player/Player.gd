"""
This is the scene that represents the player.
It has twin stick shooter controls; moving & aiming are independent of each other.
"""
extends KinematicBody2D

onready var PlayerSprite : Sprite = $Sprite

export (float) var move_speed := 90.0

func _physics_process(delta : float) -> void:
	_player_movement()
	_player_aiming()

func _player_movement() -> void:
	var input_direction := Vector2(Input.get_action_strength("player_right") - Input.get_action_strength("player_left"),
			Input.get_action_strength("player_down") - Input.get_action_strength("player_up")).normalized()
	# If I don't need 'delta' for move_and_slide, no point bringing it into 'player_movement()'
	move_and_slide(input_direction * move_speed)

func _player_aiming() -> void:
	PlayerSprite.look_at(get_global_mouse_position())