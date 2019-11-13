extends Area2D

signal nav_path_requested(self_ref)

onready var AI : StateMachine = $AI
onready var EnemySprite : Sprite = $Sprite
onready var State : Label = $State

const RAY_MASK := (1 << 0) + (1 << 2) #In collision_mask terms, this means detect 'geometry' & 'player'

export (String) var starting_state : String

var path : PoolVector2Array setget set_path

var _target : KinematicBody2D
var _original_colors : Color

func _ready() -> void:
	_original_colors = EnemySprite.modulate
	
	AI.add_states(_build_states_dictionary())
	AI.change_state(starting_state)

func _process(delta : float) -> void:
	State.text = AI.current_state

func set_path(new_path : PoolVector2Array) -> void:
	path = new_path

func get_target_location() -> Vector2:
	return position if !_target else _target.position

func is_player_in_sights() -> bool:
	if !_target:
		return false
	
	var space_state = get_world_2d().direct_space_state
	var ray_result = space_state.intersect_ray(position, _target.position, [], RAY_MASK)
	
	if ray_result:
		return ray_result.collider.is_in_group("player")
	
	return false

func _build_states_dictionary() -> Dictionary:
	return {}

func _take_damage() -> void:
	EnemySprite.modulate = Color.yellow
	yield(get_tree().create_timer(0.15), "timeout")
	EnemySprite.modulate = _original_colors

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("player_projectile"):
		if body.rebounded:
			_take_damage()
		
		body.queue_free()

func _on_PlayerDetection_body_update(body : PhysicsBody2D, entered : bool) -> void:
	_target = body if entered else null
