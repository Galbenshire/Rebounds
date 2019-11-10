extends Area2D

signal nav_path_requested(self_ref)

onready var EnemySprite : Sprite = $Sprite

const RAY_MASK := (1 << 0) + (1 << 2) #In collision_mask terms, this means detect 'geometry' & 'player'

var _target : KinematicBody2D
var _original_colors : Color
var _spotted_player : bool = false
var _ray_pos : Vector2

func _ready() -> void:
	_original_colors = EnemySprite.modulate

func _draw() -> void:
	if _target:
		draw_line(Vector2(), to_local(_ray_pos), Color.pink)

func _process(delta : float) -> void:
	update()

func _physics_process(delta : float) -> void:
	_spotted_player = _is_player_in_sights()

func get_target_location() -> Vector2:
	return position if !_target else _target.position

func update_visual_nav_path(path : PoolVector2Array) -> void:
	var localized_points = PoolVector2Array()
	
	for point in path:
		localized_points.append(to_local(point))
	
	$NavPath.points = localized_points

func _take_damage() -> void:
	EnemySprite.modulate = Color.yellow
	yield(get_tree().create_timer(0.15), "timeout")
	EnemySprite.modulate = _original_colors

func _is_player_in_sights() -> bool:
	if !_target:
		return false
	
	var space_state = get_world_2d().direct_space_state
	var ray_result = space_state.intersect_ray(position, _target.position, [], RAY_MASK)
	
	if ray_result:
		_ray_pos = ray_result.position
	
	return false

func _on_BaseEnemy_body_entered(body : PhysicsBody2D) -> void:
	if body.is_in_group("player_projectile"):
		if body.rebounded:
			_take_damage()
		
		body.queue_free()

func _on_PlayerDetection_body_entered(body : PhysicsBody2D) -> void:
	_target = body
	$NavPathUpdater.start()

func _on_PlayerDetection_body_exited(body : PhysicsBody2D) -> void:
	_target = null
	$NavPathUpdater.stop()

func _on_NavPathUpdater_timeout() -> void:
	emit_signal("nav_path_requested", self)
