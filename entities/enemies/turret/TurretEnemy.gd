extends "res://entities/enemies/BaseEnemy.gd"

onready var BulletOrigin : Position2D = $Sprite/BulletOrigin

const STATES := [
	preload("res://entities/enemies/turret/Turret_IdleState.gd"),
	preload("res://entities/enemies/turret/Turret_ActiveState.gd")
]
const BULLET = preload("res://entities/enemies/bullet/EnemyBullet.tscn")

func shoot() -> void:
	var bullet = BULLET.instance()
	bullet.angle = EnemySprite.rotation
	bullet.global_position = BulletOrigin.global_position
	get_parent().add_child(bullet)

func _build_states_dictionary() -> Dictionary:
	return {
		"idle": STATES[0],
		"active": STATES[1]
	}
