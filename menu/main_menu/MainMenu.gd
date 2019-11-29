extends Node

func _ready() -> void:
	var index = 1
	for level in $LevelGrid.get_children():
		level.connect("level_selected", self, "change_scene", [level.level_go_to])
		level.connect("focus_entered", self, "_on_level_highlighted")
		level.level_number = index
		index += 1
	$LevelGrid.get_child(0).grab_focus()

func change_scene(option : PackedScene) -> void:
	$SelectSFX.play()
	yield($SelectSFX, "finished")
	get_tree().change_scene_to(option)

func _on_level_highlighted() -> void:
	$HighlightSFX.play()
