extends KinematicBody2D
class_name Player

onready var cam : Camera2D = $Camera2D
onready var body : Node2D = $Body
onready var sprite : AnimatedSprite = $Body/AnimSprite
onready var foot_rays : Node2D = $FootRays
onready var dig_tool : DigTool = $DigTool
onready var metal_detector : MetalDetector = $MetalDetector
onready var all_sm : SStateMachine = $AllomanticSM
onready var label : Label = $UI/Label
onready var input_his := InputHistory.new()

export(float, 1.0, 10.0) var move_speed : float = 12.0
export(float, .0, 1.0) var move_accel : float = .2
export(float, 32.0, 128.0) var pushing_speed : float = 48.0
export(float, .0, 1.0) var friction : float = .5
export(float, 1.0, 10.0) var max_jump_height : float = 3.0
export(float, 1.0, 10.0) var min_jump_height : float = 1.1
export(float, .1, 5.0) var jump_duration : float = .5
export(float, 16, 32) var dig_ray_length : float = 16
export(int, 1, 10) var coyote_frames : int = 6

var snap : Vector2 = Vector2.DOWN
var vel : Vector2
var pushing : bool = false
var early_fall : bool = false
var is_grounded : bool
var frames_in_air : int = 0
var gravity : float
var max_jump_force : float
var min_jump_force : float

func _ready() -> void:
	move_speed *= Core.W_UNITS
	pushing_speed *= Core.W_UNITS
	max_jump_height *= Core.W_UNITS
	min_jump_height *= Core.W_UNITS*.5
	gravity = 2.0 * max_jump_height / pow(jump_duration, 2.0)
	max_jump_force = -sqrt(2 * gravity * max_jump_height)
	min_jump_force = -sqrt(2 * gravity * min_jump_height)

func _physics_process(delta: float) -> void:
	input_his.update()
	is_grounded = _check_grounded()
	
	if not is_grounded and frames_in_air <= coyote_frames:
		frames_in_air += 1
	elif is_grounded:
		frames_in_air = 0

func idle() -> void:
	cam.offset_h = .0
	vel.x = lerp(vel.x, .0, friction)

func move() -> void:
	cam.offset_h = input_his.current[1].x * .25
	vel.x = lerp(vel.x, input_his.current[1].x * move_speed, move_accel)
	if input_his.current[1].x != .0: body.scale.x = input_his.current[1].x 

func apply_gravity(_delta : float) -> void:
	vel.y += gravity * _delta

func jump() -> void:
	snap = Vector2.ZERO
	vel.y = max_jump_force if not pushing else vel.y + max_jump_force

func fall() -> void:
	snap = Vector2.DOWN
	vel.y = min_jump_force if early_fall else .0

func update_movement() -> void:
	vel = move_and_slide_with_snap(vel, snap, Vector2.UP)

func push_point(p: Vector2, _delta: float, heat: bool) -> Vector2:
	var _vel : Vector2 = (
		(self.global_position - p).normalized() * 
		(pushing_speed if not heat else pushing_speed * 2.0)
	) * _delta
	return _vel

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
