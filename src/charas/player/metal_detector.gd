extends Node2D
class_name MetalDetector

onready var parent := get_parent()# as Player
onready var metal_area : Area2D = $MetalArea
onready var coll_shape : Shape2D = $MetalArea/CollShape2D.get_shape()

var burning : bool = true
var frames : int = 0
var metal_points : Array = []
var tile_map : TileMap

func _physics_process(delta: float) -> void:
	if not tile_map == null:
		if burning and frames % 8 == 0 and metal_area.overlaps_body(tile_map):
			var space := tile_map.get_world_2d().get_direct_space_state()
			var check_area := _create_physics_shape(coll_shape, 
				metal_area.get_global_transform(), [parent], 
				metal_area.get_collision_layer())
			var colls : Array = space.intersect_shape(check_area)
			metal_points.clear()
			metal_points = tile_array_to_world(colls, tile_map)
		elif not burning: metal_points.clear()
		frames += 1
	else: metal_points.clear()
	update()

func _check_m_closest_p() -> Vector2:
	var m_pos : Vector2 = (
		get_global_mouse_position() - self.global_position
	).normalized()
	var highest_dot : float = -2
	var closest_point : Vector2
	for p in metal_points:
		p = p as Vector2
		var p_n : Vector2 = (p - self.global_position).normalized()
		var m_dot : float = m_pos.dot(p_n)
		if m_dot > highest_dot:
			highest_dot = m_dot
			closest_point = p
	return closest_point

func _draw() -> void:
	for p in metal_points:
		p = p as Vector2
		draw_vector(p-self.global_position, Vector2.ZERO, Color.aqua)

func _create_physics_shape(
		_shape : Shape2D, 
		_xform : Transform2D,
		_exclude : Array = [],
		_coll_layer : int = 1
) -> Physics2DShapeQueryParameters:
	
	var p_shape : Physics2DShapeQueryParameters = Physics2DShapeQueryParameters.new()
	p_shape.set_shape(_shape)
	p_shape.set_collide_with_bodies(true)
	p_shape.set_collide_with_areas(false)
	p_shape.set_transform(_xform)
	p_shape.set_exclude(_exclude)
	p_shape.set_collision_layer(_coll_layer)
	return p_shape

func tile_array_to_world(t_array : Array, _tilemap : TileMap) -> Array:
	var p_array : Array = []
	for i in t_array:
		var curr_point : Vector2 = (
			_tilemap.map_to_world(i.metadata) + _tilemap.cell_size * .5
		)
		p_array.append(curr_point)
	return p_array

func _on_MetalArea_body_entered(body: Node) -> void:
	print(body, " entered")
	if body is TileMap:
		tile_map = body

func _on_MetalArea_body_exited(body: Node) -> void:
	print(body, " exited")
	if body == tile_map:
		tile_map = null

# ---------------------------- Draw Arrow ----------------------------
const WIDTH : float = 2.0
var mul : float = .75
func draw_vector(vector: Vector2, offset: Vector2, 
		_color0: Color):
	if vector == Vector2():
		return
	var _color_mid : Color = Color(_color0.r, _color0.g, _color0.b, .6)
	var _color_end : Color = Color(_color0.r, _color0.g, _color0.b, .0)
	draw_polyline_colors(
		PoolVector2Array([offset, (vector * mul) * .8, vector * mul]), 
		PoolColorArray([_color0, _color_mid, _color_end]), 
		WIDTH, 
		true
	)
