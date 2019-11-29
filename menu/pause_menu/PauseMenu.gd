extends CanvasLayer

signal game_quit_requested()

onready var Background : ColorRect = $Background
onready var Options : VBoxContainer = $Background/Options
onready var Cursor : TextureRect = $Background/Cursor

var can_pause : bool = false

func _ready() -> void:
	for option in Options.get_children():
		option.connect("mouse_entered", self, "_auto_focus_option", [option])
		option.connect("pressed", self, "_option_selected", [option])
		option.connect("focus_entered", self, "_position_cursor", [option.rect_global_position])

func _input(event : InputEvent) -> void:
	if can_pause and event.is_action_pressed("pause"):
		var pausing_now = !get_tree().paused
		_pause(pausing_now)
		if pausing_now:
			Options.get_child(0).grab_focus()

func _pause(pause : bool) -> void:
	get_tree().paused = pause
	Background.visible = pause

func _auto_focus_option(option : Button) -> void:
	option.grab_focus()

func _position_cursor(option_position : Vector2) -> void:
	Cursor.rect_global_position = option_position
	Cursor.rect_global_position.x -= Cursor.rect_size.x
	
	$HighlightSFX.play()

func _option_selected(option : Button) -> void:
	match option.name:
		"Resume":
			_pause(false)
		"QuitLevel":
			_pause(false)
			emit_signal("game_quit_requested")
			print("Quit Level")
	
	$SelectSFX.play()