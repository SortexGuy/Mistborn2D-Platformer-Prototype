extends Node2D

const LEVELS_PATH : String = "res://src/levels/"
const LVL_EXT : String = ".lvl"
const MAX_PATTERNS : int = 3
const QUADRANT_SIZE : int = 16

export(String) var f_name : String
export(int, 0, 3) var pattern_number : int = 0
onready var level_map := $LevelMap
onready var metal_map : TileMap = $MetalMap
var file_name : String = (
	LEVELS_PATH + f_name + str(pattern_number) + LVL_EXT
) setget , _get_file_name
var save_var : Array = []

func _ready() -> void:
#	save_cells()
#	load_cells()
	for i in range(0, MAX_PATTERNS):
		load_cells(Vector2(i, 0))
		pattern_number += 1

func save_cells() -> void:
	save_var = level_map.read_cells()
	var save_file = File.new()
	var err : int = save_file.open(_get_file_name(), File.WRITE)
	if err:
		printerr("Failed opening File: ", _get_file_name(), ", Error code: ", err)
		return
	print("File opened: ", _get_file_name())
	save_file.seek_end()
#	save_file.store_line(to_json(save_var))
	for i in save_var:
		save_file.store_line(to_json(i))
	save_file.close()
	save_var.clear()
	print("Finished Saving")

func load_cells(_q_number: Vector2 = Vector2.ZERO) -> void:
	var save_file = File.new()
	var err : int = save_file.open(_get_file_name(), File.READ)
	if err:
		printerr("Failed opening File: ", _get_file_name(), ", Error code: ", err)
		return
	print("File opened: ", _get_file_name())
	# Open file ^
	
	var y : int = 0
	while not save_file.eof_reached(): # While loop bc i cant know the number of lines
		var y_arr = parse_json(save_file.get_line())
		if y_arr == null: break
		# Read File ^
		
		for x in range(0, y_arr.size()):
			randomize()
			if y_arr[x] == 1:
# warning-ignore:narrowing_conversion
# warning-ignore:narrowing_conversion
				metal_map.set_cell(x + (_q_number.x * QUADRANT_SIZE), 
					y + (_q_number.y * QUADRANT_SIZE), 
					1, false, false, false, Vector2(
						randi() % 4, randi() % 4
					))
				level_map.set_cellv(Vector2(
						x + (_q_number.x * QUADRANT_SIZE), 
						y + (_q_number.y * QUADRANT_SIZE)
					), 0)
			else:
				level_map.set_cellv(Vector2(
						x + (_q_number.x * QUADRANT_SIZE), 
						y + (_q_number.y * QUADRANT_SIZE)
					), y_arr[x])
		y += 1
	save_file.close()
	level_map.update_bitmask_region()

func _get_file_name() -> String:
	file_name = (LEVELS_PATH + f_name + str(pattern_number) + LVL_EXT)
	return file_name

#func read_cells() -> Array:
#	var cells : Array = []
#	for y in range(0, QUADRANT_SIZE):
#		var x_cells : Array = []
#		for x in range(0, QUADRANT_SIZE):
#			var cell : int = get_cell(x, y)
#			var push_x
#			if cell == 0:
##				push_x = get_cell_autotile_coord(x,y)
#				push_x = cell
#			else: push_x = cell
#			x_cells.push_back(push_x)
#		cells.push_back(x_cells.duplicate(true))
#	print("Finished reading")
#	return cells
