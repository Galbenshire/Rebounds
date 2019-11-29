extends State
"""
In this state, the enemy does nothing.
When it can see the player, it calls for a state change.
"""

const PATH_UPDATE_RATE := 0.5
const MOVE_SPEED := 70.0

var update_timer := 0.0 #A timer? Without a Timer?

func physics_process(delta : float) -> void:
	if target.is_player_in_sights():
		_run_update_timer(delta)
	
	if target.distance_to_target() < 32:
		emit_signal("transition_call_made", "attack")
		return
	
	if target.path.size() > 0:
		_move_along_path(delta)
	else:
		emit_signal("transition_call_made", "idle")

func on_enter() -> void:
	_update_path()

func on_exit() -> void:
	update_timer = 0.0

func _update_path() -> void:
	target.emit_signal("nav_path_requested", target)

func _move_along_path(delta : float) -> void:
	var travel_speed = min(MOVE_SPEED * delta, target.position.distance_to(target.path[0]))
	var travel_direction = (target.path[0] - target.position).normalized()
	
	target.position += travel_direction * travel_speed
	target.EnemySprite.rotation = travel_direction.angle()
	
	if target.position.distance_to(target.path[0]) < 3:
		target.remove_front_point()

func _run_update_timer(delta : float) -> void:
	update_timer += delta
	if update_timer > PATH_UPDATE_RATE:
		_update_path()
		update_timer -= PATH_UPDATE_RATE