extends TileMap
class_name LevelMap

const QUADRANT_SIZE : int = 16

func read_cells() -> Array:
	var cells : Array = []
	for y in range(0, QUADRANT_SIZE):
		var x_cells : Array = []
		for x in range(0, QUADRANT_SIZE):
			var cell : int = get_cell(x, y)
			var push_x
			if cell == 0:
#				push_x = get_cell_autotile_coord(x,y)
				push_x = cell
			else: push_x = cell
			x_cells.push_back(push_x)
		cells.push_back(x_cells.duplicate(true))
		print("Readed Y: ", y)
	print("Finished reading")
	return cells

func write_cells(_cells : Array) -> void:
	for y in range(0, _cells.size()):
		for x in range(0, _cells[y].size()):
			var curr_tile
			if _cells[y][x] is String:
				curr_tile = _cells[y][x] as String
				curr_tile.replace(", ", ",")
				curr_tile.trim_prefix("(")
				curr_tile.trim_suffix(")")
				
				var tile_cord : Vector2 = Vector2(
					curr_tile.split(",")[0].to_int()
					,
					curr_tile.split(",")[1].to_int()
				)
				set_cell(x, y, 0, false, false, false, tile_cord)
			else:
				curr_tile = _cells[y][x] as int
				set_cell(x, y, curr_tile, false, false, false, Vector2(1,0))
#			yield(get_tree().create_timer(0.01666/2), "timeout")
#		yield(get_tree().create_timer(0.01666), "timeout")
