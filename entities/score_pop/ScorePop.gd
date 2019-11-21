extends Node2D

func _ready():
	$Tween.interpolate_property(self, "position:y", position.y, position.y - 24.0, 1.0, Tween.TRANS_QUART, Tween.EASE_OUT)
	$Tween.interpolate_callback(self, 2.0, "queue_free")
	$Tween.start()

func set_score(score : int) -> void:
	$Label.text = str(score)