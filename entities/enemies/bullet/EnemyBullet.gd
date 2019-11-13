extends Area2D

export (float) var move_speed := 200.0 setget set_move_speed
export (float) var angle := 0.0 setget set_angle

var _velocity : Vector2

func _ready() -> void:
	_update_velocity()

func _physics_process(delta : float) -> void:
	position += _velocity * delta

func set_move_speed(value : float) -> void:
	move_speed = value
	_update_velocity()

func set_angle(value : float) -> void:
	angle = value
	_update_velocity()

func _update_velocity() -> void:
	_velocity = Vector2(cos(angle), sin(angle)) * move_speed

func _on_body_entered(body : PhysicsBody2D) -> void:
	queue_free()

func _on_VisibilityNotifier_screen_exited() -> void:
	queue_free()

func _on_GeometryPasser_timeout() -> void:
	$Collision.set_deferred("disabled", false)
