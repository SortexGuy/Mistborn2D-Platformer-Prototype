extends PlayerState

var frames_in : int = 0

func enter(_msg : Dictionary = {}) -> void:
	player.jump()
	player.sprite.set_animation("Jump")

func physics_update(_delta : float) -> void:
	
	player.apply_gravity(_delta)
	player.update_movement() # Move the player
	player.move() # Set normal vel
	_transitions(_delta)

func _transitions(_delta : float) -> void:
	frames_in += 1
	if player.vel.y >= .0 or player.check_fall():
		player.early_fall = player.check_fall()
		frames_in = 0
		state_machine.transition_to("Fall")
	elif player.is_grounded and frames_in >= 4:
		if player.input_his.current[1].x == .0:
			frames_in = 0
			state_machine.transition_to("Idle")
		elif player.input_his.current[1].x != .0:
			frames_in = 0
			state_machine.transition_to("Move")
	elif Input.is_action_just_pressed("dig"):
		state_machine.transition_to("Dig")
