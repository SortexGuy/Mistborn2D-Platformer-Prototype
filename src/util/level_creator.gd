extends Node2D

const LEVELS_PATH : String = "res://src/levels/"

export(String) onready var file_name : String
onready var level_map := $LevelMap
onready var file_ : String = (LEVELS_PATH + file_name)
var save_var : Array = []

func _ready() -> void:
	save_cells()
#	load_cells()

func save_cells() -> void:
	save_var = level_map.read_cells()
	var save_file = File.new()
	var err : int = save_file.open(file_, File.WRITE)
	if err:
		print("Failed opening File: ", file_, ", Error code: ", err)
		return
	print("File opened: ", file_)
	save_file.seek_end()
	save_file.store_line(to_json(save_var))
	save_file.close()
	save_var.clear()
	print("Finished Saving")

func load_cells() -> void:
	var save_file = File.new()
	var err : int = save_file.open(file_, File.READ)
	if err:
		print("Failed opening File: ", file_, ", Error code: ", err)
		return
	print("File opened: ", file_)
	var varying = parse_json(save_file.get_line())
	save_file.close()
	level_map.write_cells(varying)
