extends TileMap

func explode() -> void:
	var explosion = preload("res://entities/explosion/Explosion.tscn")
	var expl = explosion.instance()
	expl.global_position = _calculate_explosion_position()
	get_parent().add_child(expl)
	
	_remove_barrier()

func _calculate_explosion_position() -> Vector2:
	var tile_rect = get_used_rect()
	tile_rect.size *= cell_size
	var center = tile_rect.size * 0.5
	
	return to_global(center)

func _remove_barrier() -> void:
	for cell in get_used_cells():
		set_cell(cell.x, cell.y, 0)
	modulate = Color.white