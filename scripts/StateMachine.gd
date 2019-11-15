extends Node
class_name StateMachine
"""
A node script designed to handle the flow of logic.

State Machines are a way of controlling & maintaining the execution flow of logic.
They are usually used for AI in enemies, or for seperating various player states.

Simply create an empty Node as a child of a Scene, then attach this script.
In the owner Scene's script, in the _ready() function, use add_states() with a Dictionary
of your desired states. Remember to then call change_state() to set the starting state.

EXAMPLE:
var AI = $StateMachine

func _ready() -> void:
	AI.add_states({
		'idle': <IDLESTATE>,
		'follow': <FOLLOWSTATE>
	})
	AI.change_state('idle')

~~~~~~~

I've seen various examples of State Machines for Godot. However, I noticed that the majority
of them use Nodes for the whole thing: The State Machine is a Node, and States are Nodes.
A part of me believed that using that many Nodes seemed unnecessary.

One exception I saw was the design by Game Endevour (https://youtu.be/BNU8xNRk_oU),
where the whole thing is one Node script, and the code for each state is in the state machine itself.
It's simple and it works, but it can still lead to code clutter if you intend to make large AIs.

Another example was by Brendon Lamb (https://github.com/godot-addons/godot-finite-state-machine).
This one made both the State Machine & States extend from Reference, rather than Node.
This makes them more lightweight.
However, the code was dynamic-typed. I tried converting it to static-typing,
but for some reason I ended up with coder's block.

In the end, I made my own. As you'll see, the State Machine itself is a Node, but the States are References.
I think it's fine for the State Machine to be a Node since it is significant,
and you'll usually only have one State Machine.
States however, are References, to make them more lightweight.
"""

var states : Dictionary = {}
var current_state : String setget set_current_state

var _current_state_internal : State

func _input(event : InputEvent) -> void:
	if _current_state_internal:
		_current_state_internal.input(event)

func _process(delta : float) -> void:
	if _current_state_internal:
		_current_state_internal.process(delta)

func _physics_process(delta : float) -> void:
	if _current_state_internal:
		_current_state_internal.physics_process(delta)

func set_current_state(new_state : String) -> void:
	if new_state in states:
		current_state = new_state
		_current_state_internal = states[new_state]
	else:
		printerr("Error! Trying to set to a non-existant state (%s)!" % new_state)

func add_states(new_states : Dictionary) -> void:
	for s in new_states:
		var new_state =  new_states[s].new()
		new_state.id = s
		new_state.target = owner
		new_state.connect("transition_call_made", self, "change_state")
		states[s] = new_state

func change_state(new_state : String) -> void:
	if !new_state in states:
		printerr("Error! Trying to transition to a non-existant state (%s)!" % new_state)
		return
	
	if current_state in states:
		states[current_state].on_exit()
	if new_state in states:
		states[new_state].on_enter()
	
	set_current_state(new_state)