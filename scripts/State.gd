extends Reference
class_name State
"""
A segment of behaviour whose logic is specific to only itself.

States, together with State Machines, can allow for more complex behaviours, and seperating code
into specific segments.
The data and logic in each State is relevant only to itself.
No other States in a State Machine needs to know about the contents.

A State has an id (for the State Machine) & a target (a Node that owns this State).
When it's ready to make a switch, a signal is emitted for the State Machine to listen to.

There is no need to make a State yourself; the State Machine will create them for you.
"""

signal transition_call_made(new_state)

var id : String
var target : Node

func input(event : InputEvent) -> void:
	pass

func process(delta : float) -> void:
	pass

func physics_process(delta : float) -> void:
	pass

func on_enter() -> void:
	pass

func on_exit() -> void:
	pass