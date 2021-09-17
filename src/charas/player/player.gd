extends KinematicBody2D
class_name Player

onready var cam : Camera2D = $Camera2D
onready var body : Node2D = $Body
onready var sprite : AnimatedSprite = $Body/AnimSprite
onready var dig_gizmo : MeshInstance2D = $DigGizmo
onready var foot_rays : Node2D = $FootRays
onready var dig_ray : RayCast2D = $DigRay
onready var label : Label = $UI/Label
onready var input_his := InputHistory.new()

export(float, 1.0, 10.0) var move_speed : float = 8.0
export(float, .0, 1.0) var move_accel : float = .3
export(float, 1.0, 10.0) var max_jump_height : float = 3.0
export(float, 1.0, 10.0) var min_jump_height : float = 1.1
export(float, .1, 5.0) var jump_duration : float = .5
export(float, 16, 32) var dig_ray_length : float = 16
export(int, 1, 10) var coyote_frames : int = 6

var snap : Vector2 = Vector2.DOWN
var vel : Vector2
var early_fall : bool = false
var is_grounded : bool
var frames_in_air : int = 0
var gravity : float
var max_jump_force : float
var min_jump_force : float

func _ready() -> void:
	move_speed *= Core.W_UNITS
	max_jump_height *= Core.W_UNITS
	min_jump_height *= Core.W_UNITS*.5
	gravity = 2.0 * max_jump_height / pow(jump_duration, 2.0)
	max_jump_force = -sqrt(2 * gravity * max_jump_height)
	min_jump_force = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta: float) -> void:
	input_his.update()
	is_grounded = _check_grounded()
	dig_ray.look_at(get_global_mouse_position())
	# Dig Ray Gizmo
	if dig_ray.is_colliding():
		if not dig_gizmo.visible: dig_gizmo.visible = true 
		dig_gizmo.global_position = dig_ray.get_collision_point()
	else: dig_gizmo.visible = false
	
	if not is_grounded and frames_in_air <= coyote_frames:
		frames_in_air += 1
	elif is_grounded:
		frames_in_air = 0

func dig() -> void:
	dig_ray.force_raycast_update()
	if dig_ray.is_colliding():
		if not dig_ray.get_collider() is LevelMap:
			return
		var coll : LevelMap = dig_ray.get_collider() as LevelMap
		var coll_point : Vector2 = dig_ray.get_collision_point() + (
			dig_ray.get_collision_point() - self .global_position).normalized()
		var x : int = int(coll.world_to_map(coll_point).x)
		var y : int = int(coll.world_to_map(coll_point).y)
		coll.set_cell(x, y, -1)

func idle() -> void:
	cam.offset_h = .0
	vel.x = lerp(vel.x, .0, move_accel)

func move() -> void:
	cam.offset_h = input_his.current[1].x * .25
	vel.x = lerp(vel.x, input_his.current[1].x * move_speed, move_accel)
	if input_his.current[1].x != .0: body.scale.x = input_his.current[1].x 

func apply_gravity(_delta : float) -> void:
	vel.y += gravity * _delta

func jump() -> void:
	snap = Vector2.ZERO
	vel.y = max_jump_force

func fall() -> void:
	snap = Vector2.DOWN
	vel.y = min_jump_force if early_fall else .0

func update_movement() -> void:
	vel = move_and_slide_with_snap(vel, snap, Vector2.UP)

func check_jump() -> bool:
	if ((is_grounded or frames_in_air < coyote_frames) and 
		input_his.current[2] and input_his.current[0] <= 7): return true
	return false

func check_fall() -> bool:
	if not input_his.current[2] and vel.y < min_jump_force: return true
	return false

func _check_grounded() -> bool:
	for ray in foot_rays.get_children():
		if ray.is_colliding():
			return true
	return false
