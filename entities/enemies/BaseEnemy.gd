extends Area2D

signal nav_path_requested(self_ref)

onready var AI : StateMachine = $AI
onready var EnemySprite : Sprite = $Sprite
onready var HurtTimer : Timer = $HurtTimer
onready var State : Label = $State

const PlayerData := preload("res://scriptable_objects/PlayerData.tres")

const EXPLOSION := preload("res://entities/explosion/Explosion.tscn")
const RAY_MASK := (1 << 0) + (1 << 2) #In collision_mask terms, this means detect 'geometry' & 'player'

export (int) var starting_health : int = 5
export (String) var starting_state : String
export (int) var score_value : int = 100

var health : int
var path : PoolVector2Array setget set_path

var _target : KinematicBody2D
var _original_colors : Color

func _ready() -> void:
	health = starting_health
	_original_colors = EnemySprite.modulate
	
	AI.add_states(_build_states_dictionary())
	AI.change_state(starting_state)

func _process(delta : float) -> void:
	State.text = AI.current_state

func set_path(new_path : PoolVector2Array) -> void:
	path = new_path
	path.remove(0)

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

func distance_to_target() -> float:
	if !_target:
		return 0.0
	
	return position.distance_to(_target.position)

func remove_front_point() -> void:
	path.remove(0)

func _build_states_dictionary() -> Dictionary:
	return {}

func _take_damage() -> void:
	health -= 1
	if health <= 0:
		_die()
	else:
		EnemySprite.modulate = Color.yellow
		HurtTimer.start()
		$HurtSFX.play()

func _die() -> void:
	_make_explosion()
	_pop_score()
	
	PlayerData.score += score_value
	queue_free()

func _make_explosion() -> void:
	var explosion = EXPLOSION.instance()
	explosion.global_position = global_position
	get_parent().add_child(explosion)

func _pop_score() -> void:
	var score_pop = preload("res://entities/score_pop/ScorePop.tscn")
	var sp = score_pop.instance()
	sp.set_score(score_value)
	sp.global_position = global_position
	get_parent().add_child(sp)

func _on_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("player_projectile"):
		if body.rebounded:
			_take_damage()
		
		body.queue_free()

func _on_PlayerDetection_body_update(body : PhysicsBody2D, entered : bool) -> void:
	_target = body if entered else null

func _on_HurtTimer_timeout() -> void:
	EnemySprite.modulate = _original_colors
