#extends StateMachine

onready var player : Player = get_parent() as Player

func _ready() -> void:
	add_state("idle")
	add_state("move")
	add_state("jump")
	add_state("fall")
	add_state("dig")
	call_deferred("set_state", states.idle)

func _state_logic(_delta : float) -> void:
	player.input_his.update()
#	player.dig_ray.look_at(player.get_global_mouse_position())
	player.is_grounded = player._check_grounded()
	player.snap = Vector2.DOWN if player.is_grounded else Vector2.ZERO
	
	if Input.is_action_just_pressed("dig"):
		player.dig()
	
	player.update_movement() # Move the player
	if not player.is_grounded: player.apply_gravity(_delta)
	player.move() # Set normal vel

func _get_transition(_delta : float) -> int:
	match state:
		states.idle:
			# On idle state
			if player.check_jump():
				return states.jump
			elif (not player.is_grounded and player.vel.y > .0):
				player.early_fall = player.check_fall()
				return states.fall
			elif player.input_his.current[0].x != .0:
				return states.move
		states.move:
			# On move state
			if player.check_jump():
				return states.jump
			elif (not player.is_grounded and player.vel.y > .0):
				player.early_fall = player.check_fall()
				return states.fall
			elif player.input_his.current[0].x == .0:
				return states.idle
		states.jump:
			if player.vel.y >= .0 or player.check_fall():
				player.early_fall = player.check_fall()
				return states.fall
			elif player.is_grounded and is_equal_approx(player.vel.y, .0):
				if player.input_his.current[0].x != .0:
					return states.move
				elif player.input_his.current[0].x == .0:
					return states.idle
		states.fall:
			if player.is_grounded:
				if player.input_his.current[0].x != .0:
					return states.move
				elif player.input_his.current[0].x == .0:
					return states.idle
			elif player.check_jump():
				return states.jump
	return -1

func _enter_state(new_state : int, _old_state : int) -> void:
	match new_state:
		states.jump:
			player.jump()
		states.fall:
			if player.early_fall: player.fall()
