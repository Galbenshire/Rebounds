extends ColorRect

const PlayerData := preload("res://scriptable_objects/PlayerData.tres")

func _ready() -> void:
	PlayerData.connect("values_changed", self, "update_banner")
	update_banner()

func update_banner() -> void:
	$Life.text = str("LIFE - %d" % PlayerData.life)
	$Score.text = str("SCORE - %d" % PlayerData.score)
