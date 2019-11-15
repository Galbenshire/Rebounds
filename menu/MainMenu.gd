extends Node

func _ready() -> void:
	$TestLevelButton.connect("pressed", self, "change_scene", ["res://levels/level_test_2/TestLevel2.tscn"])
	$TestLevelButton2.connect("pressed", self, "change_scene", ["res://levels/level_test_1/TestLevel1.tscn"])

func change_scene(scene : String) -> void:
	get_tree().change_scene(scene)
