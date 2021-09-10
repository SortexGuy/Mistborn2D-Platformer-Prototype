extends TileMap
class_name LevelMap

const QUADRANT_SIZE : int = 16

#func _ready() -> void:
#	_on_start()

func read_cells() -> Array:
	var cells : Array = []
	for y in range(0, QUADRANT_SIZE):
		var x_cells : Array = []
		for x in range(0, QUADRANT_SIZE):
			var cell : int = get_cell(x, y)
			x_cells.push_back(cell)
		cells.push_back(x_cells.duplicate(true))
		print("Readed Y: ", y, ", Time passed: ")
	print("Finished reading")
	return cells

func write_cells(_cells : Array) -> void:
	
	for y in range(0, _cells.size()):
		for x in range(0, _cells.size()):
			pass
	

#func set_cell(x:int, y:int, tile:int, flip_x:bool=false, flip_y:bool=false, 
#					transpose:bool=false, autotile_coord:Vector2=Vector2()):
#	.set_cell(x, y, tile, flip_x, flip_y, transpose, autotile_coord)
#	update_dirty_quadrants()

func _on_start() -> void:
	for y in range(0, 6):
		if y < 3:
			for x in range(0, 16):
				set_cell(x, y, 0, false, false, false, Vector2(1,0))
		else:
			for x in range(0, 20):
				set_cell(x-2, y, 0, false, false, false, Vector2(1,0))
