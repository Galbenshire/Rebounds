extends Area2D

onready var EnemySprite : Sprite = $Sprite

var original_colors : Color

func _ready() -> void:
	original_colors = EnemySprite.modulate

func _take_damage() -> void:
	EnemySprite.modulate = Color.yellow
	yield(get_tree().create_timer(0.15), "timeout")
	EnemySprite.modulate = original_colors

func _on_BaseEnemy_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("player_projectile"):
		if body.rebounded:
			_take_damage()
		
		body.queue_free()
