"""
This is the scene that represents the player.
It has twin stick shooter controls; moving & aiming are independent of each other.

There is support for both controllers & keyboard/mouse.
Depending on which is used, the code will adjust accordingly.
"""
extends KinematicBody2D

signal died()

onready var PlayerSprite : Sprite = $Sprite
onready var BulletOrigin : Position2D = $Sprite/BulletOrigin
onready var Hitbox : Area2D = $Hitbox/Collision
onready var BlinkAnimation : AnimationPlayer = $BlinkAnimation
onready var HurtTimer : Timer = $HurtTimer

const PlayerData := preload("res://scriptable_objects/PlayerData.tres")

const BULLET := preload("res://entities/player/bullet/PlayerBullet.tscn")
const EXPLOSION := preload("res://entities/explosion/Explosion.tscn")
const STICK_DEADZONE := 0.3
const MAX_BULLETS_ON_SCREEN = 3

export (float) var move_speed := 90.0

var _mouse_mode : bool = false

func _ready() -> void:
	PlayerData.reset_life()

func _unhandled_input(event : InputEvent) -> void:
	if _mouse_mode and _is_gamepad_used(event):
		_mouse_mode = false
	elif !_mouse_mode and _is_keyboard_used(event):
		_mouse_mode = true
	
	if event.is_action_pressed("player_shoot"):
		_player_shoot()

func _physics_process(delta : float) -> void:
	_player_movement()
	_player_aiming()

func set_control_state(value : bool) -> void:
	set_physics_process(value)
	set_process_unhandled_input(value)

func set_camera_bounds(bounds : Rect2) -> void:
	$Camera.limit_left = bounds.position.x
	$Camera.limit_top = bounds.position.y
	$Camera.limit_right = bounds.end.x
	$Camera.limit_bottom = bounds.end.y

func take_damage() -> void:
	if BlinkAnimation.is_playing():
		return
	
	PlayerData.life -= 1
	if PlayerData.life <= 0:
		die()
	else:
	# Start hurt invincibility
		BlinkAnimation.play("blink")
		HurtTimer.start()

func die() -> void:
	var explosion = EXPLOSION.instance()
	explosion.global_position = global_position
	get_parent().add_child(explosion)
	
	hide()
	Hitbox.set_deferred("disabled", true)
	$Collider.set_deferred("disabled", true)
	set_control_state(false)
	emit_signal("died")

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

func _player_shoot() -> void:
	if get_tree().get_nodes_in_group("player_projectile").size() >= MAX_BULLETS_ON_SCREEN:
		return
	
	var bullet = BULLET.instance()
	bullet.angle = PlayerSprite.rotation
	bullet.global_position = BulletOrigin.global_position
	get_parent().add_child(bullet)

func _on_Hitbox_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("player_projectile"):
		if body.rebounded:
			take_damage()
			body.queue_free()

func _on_Hitbox_area_entered(area : Area2D) -> void:
	take_damage()
	area.queue_free()
	
# Stop invincibility
func _on_HurtTimer_timeout() -> void:
	BlinkAnimation.stop()
	PlayerSprite.visible = true
