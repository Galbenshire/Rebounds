extends Area2D

onready var FinSprite : Sprite = $Sprite

func _process(delta : float) -> void:
	FinSprite.rotate(0.08)

func _on_FinishPoint_body_entered(body : PhysicsBody2D) -> void:
	print("The player has reached the end.")
