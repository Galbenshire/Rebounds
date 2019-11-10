extends Area2D

signal player_reached_end()

onready var FinSprite : Sprite = $Sprite

func _process(delta : float) -> void:
	FinSprite.rotate(0.08)

func _on_FinishPoint_body_entered(body : PhysicsBody2D) -> void:
	print("The player has reached the end.")
	emit_signal("player_reached_end")
