extends Panel

signal level_selected()

const STYLES := {
	"normal": preload("res://menu/main_menu/level_selection/LevelSelection_Normal.tres"),
	"highlighted": preload("res://menu/main_menu/level_selection/LevelSelection_Highlighted.tres")
}

export (PackedScene) var level_go_to : PackedScene

var level_number : int = 1 setget set_level_number

func _input(event : InputEvent) -> void:
	if !has_focus():
		return
	
	if event.is_action_pressed("ui_accept"):
		emit_signal("level_selected")
		accept_event()

func _gui_input(event : InputEvent) -> void:
	if !event is InputEventMouseButton:
		return
	
	if event.button_index == BUTTON_LEFT and event.is_pressed():
		emit_signal("level_selected")
		accept_event()

func set_level_number(value : int) -> void:
	level_number = value
	$Number.text = str(level_number)

func _on_focus_updated(entered : bool) -> void:
	var new_style = STYLES["highlighted"] if entered else STYLES["normal"]
	set("custom_styles/panel", new_style)
