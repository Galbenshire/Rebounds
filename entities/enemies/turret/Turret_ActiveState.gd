extends State
"""
In this state, the turret will rotate towards the player.
"""

const ROTATION_SPEED := 3.0
const SHOOT_COOLDOWN := 1.5

var shoot_timer := 1.0
var current_angle := Vector2.RIGHT
var target_angle := Vector2.RIGHT

func physics_process(delta : float) -> void:
	if target.is_player_in_sights():
		_aim_towards_player(delta)
		_shooting(delta)
	else:
		emit_signal("transition_call_made", "idle")

func _aim_towards_player(delta : float) -> void:
	current_angle = Vector2.RIGHT.rotated(target.EnemySprite.rotation)
	target_angle = (target.get_target_location() - target.position).normalized()
	
	target.EnemySprite.rotation = current_angle.linear_interpolate(target_angle, ROTATION_SPEED * delta).angle()

func _shooting(delta : float) -> void:
	if !target_angle.dot(current_angle) > 0.9:
		return
	
	shoot_timer += delta
	if shoot_timer > SHOOT_COOLDOWN:
		target.shoot()
		shoot_timer -= SHOOT_COOLDOWN