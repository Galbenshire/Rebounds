tool
extends Area2D

export (Color) var color = Color.white setget set_color
export (NodePath) var barrier_path : NodePath setget set_barrier_path

var _barrier : TileMap

func set_color(value : Color) -> void:
	color = value
	modulate = color
	if _barrier:
		_barrier.modulate = color

func set_barrier_path(path : NodePath) -> void:
	if !Engine.editor_hint:
		yield(self, "tree_entered")
	barrier_path = path
	var path_node = get_node_or_null(barrier_path)
	if path_node is TileMap:
		_barrier = path_node
	else:
		_barrier = null
		printerr("ERROR! Only use TileMaps for 'Barrier Path' for 'Key'")

func _remove_self() -> void:
	hide()
	$Collision.set_deferred("disabled", true)
	$CollectSFX.play()
	yield($CollectSFX, "finished")
	queue_free()

func _on_body_entered(body : PhysicsBody2D) -> void:
	if !Engine.editor_hint:
		_remove_self()
		if _barrier:
			_barrier.explode()
