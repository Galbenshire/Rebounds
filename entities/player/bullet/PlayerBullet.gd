"""
The player's projectiles.
They can bounce off walls; this is required before they can hurt enemies.
Make sure they don't hurt you though.
"""
extends KinematicBody2D

export (float) var move_speed := 200.0 setget set_move_speed
export (float) var angle := 0.0 setget set_angle

var rebounded : bool = false

var _velocity : Vector2

func _ready() -> void:
	_update_velocity()

func _physics_process(delta : float) -> void:
	var collision := move_and_collide(_velocity * delta)
	if collision:
		if rebounded:
			queue_free()
		else:
			set_angle(_velocity.bounce(collision.normal).angle())
			$Sprite.modulate = Color.red
			rebounded = true

func set_move_speed(value : float) -> void:
	move_speed = value
	_update_velocity()

func set_angle(value : float) -> void:
	angle = value
	_update_velocity()

func _update_velocity() -> void:
	_velocity = Vector2(cos(angle), sin(angle)) * move_speed