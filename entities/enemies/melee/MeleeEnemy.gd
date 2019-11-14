extends "res://entities/enemies/BaseEnemy.gd"

const STATES := [
	preload("res://entities/enemies/melee/Melee_IdleState.gd"),
	preload("res://entities/enemies/melee/Melee_FollowState.gd")
]

func _build_states_dictionary() -> Dictionary:
	return {
		"idle": STATES[0],
		"follow": STATES[1]
	}
