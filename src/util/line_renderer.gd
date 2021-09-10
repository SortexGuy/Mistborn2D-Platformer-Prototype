extends Node2D

export(float, 8.0, 64.0) var MAX_LENGTH : float = 32.0
export(float, .1, 6.0) var THICKNESS : float = 3.0

var points : Array = []
var frame : int = 0

func _physics_process(_delta):
	if frame % 3 == 0:
		points.push_front(global_position)
		if points.size() > MAX_LENGTH:
			points.pop_back()
	frame += 1
	update()

func _draw():
	if points.size() < 2: return
	
	var antialias : bool = true
	var c : = modulate
	var s : float = float(points.size())
	var adjusted : PoolVector2Array = PoolVector2Array()
	var colors : PoolColorArray = PoolColorArray()
	
	for i in range(s):
		adjusted.append(points[i] - global_position)
		c.a = lerp(1.0, .0, i/s)
		colors.append(c)
	
	draw_set_transform(Vector2(0,0), -get_parent().rotation, Vector2(1,1))
	draw_polyline_colors(adjusted, colors, THICKNESS, antialias)
