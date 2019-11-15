extends State
"""
In this state, the enemy does a melee attack.
It goes back to following when finished.
"""

func physics_process(delta : float) -> void:
	if target.is_finished_attacking():
		emit_signal("transition_call_made", "follow")

func on_enter() -> void:
	target.AttackAnimations.play("attack")
