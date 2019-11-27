extends AnimatedSprite

var is_small : bool = false

func _ready() -> void:
	play("small" if is_small else "big")
	if is_small:
		$SmallExplodeSFX.play()

func _on_animation_finished() -> void:
	queue_free()
