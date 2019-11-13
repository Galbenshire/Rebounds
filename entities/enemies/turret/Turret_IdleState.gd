extends State
"""
In this state, the turret does nothing.
When it can see the player, it calls for a state change.
"""

func physics_process(delta : float) -> void:
	if target.is_player_in_sights():
		emit_signal("transition_call_made", "active")
