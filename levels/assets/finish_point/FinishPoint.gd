extends Area2D

signal player_reached_end()

onready var OuterRing : Sprite = $OuterRing
onready var InnerRing : Sprite = $InnerRing

func _process(delta : float) -> void:
	_rotate_ring(OuterRing, 0.08)
	_rotate_ring(InnerRing, -0.08)

func _rotate_ring(ring : Sprite, speed : float) -> void:
	ring.rotate(speed)

func _on_FinishPoint_body_entered(body : PhysicsBody2D) -> void:
	print("The player has reached the end.")
	body.set_deferred("position", position)
	emit_signal("player_reached_end")

func _on_ColorTimer_timeout() -> void:
	for ring in [OuterRing, InnerRing]:
		ring.modulate.v = 1.0 if ring.modulate.v == 0.0 else 0.0
