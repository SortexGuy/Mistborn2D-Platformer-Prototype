extends Line2D

export(int, 2, 32) var MAX_LENGTH : int = 16
onready var parent : = get_parent()
var point : Vector2
var frame : int = 0

func _physics_process(_delta):
	global_position = Vector2(0,0)
	global_rotation = .0
	if frame >= 2:
		point = parent.global_position
		add_point(point)
		while get_point_count() > MAX_LENGTH:
			remove_point(0)
		frame = 0
	frame += 1
