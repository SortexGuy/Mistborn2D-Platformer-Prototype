extends Node2D
class_name DigTool

onready var dig_ray : = $DigRay
onready var dig_gizmo : = $DigGizmo

func _physics_process(delta: float) -> void:
	dig_ray.look_at(get_global_mouse_position())
	# Dig Ray Gizmo
	if dig_ray.is_colliding():
		if not dig_gizmo.visible: dig_gizmo.visible = true 
		dig_gizmo.global_position = dig_ray.get_collision_point()
	else: dig_gizmo.visible = false

func dig() -> void:
	dig_ray.force_raycast_update()
	if dig_ray.is_colliding():
		if not dig_ray.get_collider() is TileMap:
			return
		var coll : TileMap = dig_ray.get_collider() as TileMap
		var coll_point : Vector2 = dig_ray.get_collision_point() + (
			dig_ray.get_collision_point() - self .global_position).normalized()
		var x : int = int(coll.world_to_map(coll_point).x)
		var y : int = int(coll.world_to_map(coll_point).y)
		coll.set_cell(x, y, -1)
		coll.update_bitmask_region()
