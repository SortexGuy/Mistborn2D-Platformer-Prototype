extends PlayerState

func enter(_msg : Dictionary = {}) -> void:
#	if player.early_fall: 
	player.fall()
	player.sprite.set_animation("Fall")

func physics_update(_delta : float) -> void:
	
	player.apply_gravity(_delta)
	player.update_movement() # Move the player
	player.move() # Set normal vel
	_transitions(_delta)

func _transitions(_delta : float) -> void:
	if player.check_jump():
		state_machine.transition_to("Jump")
	elif player.is_grounded:
		if player.input_his.current[1].x == .0:
			state_machine.transition_to("Idle")
		elif player.input_his.current[1].x != .0:
			state_machine.transition_to("Move")
