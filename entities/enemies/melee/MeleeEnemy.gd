extends "res://entities/enemies/BaseEnemy.gd"

onready var AttackAnimations : AnimationPlayer = $AttackAnimations
onready var PathVisual : Line2D = $Debug/PathVisual

const STATES := [
	preload("res://entities/enemies/melee/Melee_IdleState.gd"),
	preload("res://entities/enemies/melee/Melee_FollowState.gd"),
	preload("res://entities/enemies/melee/Melee_AttackState.gd")
]

func set_path(new_path : PoolVector2Array) -> void:
	path = new_path
	PathVisual.points = path
	path.remove(0)

func aim_at_target() -> void:
	if !_target:
		return
	
	EnemySprite.look_at(_target.position)

func is_finished_attacking() -> bool:
	return !AttackAnimations.is_playing()

func _build_states_dictionary() -> Dictionary:
	return {
		"idle": STATES[0],
		"follow": STATES[1],
		"attack": STATES[2]
	}

func _on_MeleeHitbox_body_entered(body : PhysicsBody2D) -> void:
	body.take_damage()
