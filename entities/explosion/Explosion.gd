extends AnimatedSprite

onready var SoundHold : SoundHolder = $SoundHolder

var is_small : bool = false

func _ready() -> void:
	play("small" if is_small else "big")
	SoundHold.play("SmallExplode" if is_small else "BigExplode")

func _on_animation_finished() -> void:
	queue_free()
