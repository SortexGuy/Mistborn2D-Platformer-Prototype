extends PlayerState

func enter(_msg : Dictionary = {}) -> void:
	player.snap = Vector2.DOWN
	player.sprite.set_animation("Slash")
	player.dig()

func physics_update(_delta : float) -> void:
	
	if not player.is_grounded: player.apply_gravity(_delta)
	player.update_movement() # Move the player
	player.idle() # Set normal vel
	_transitions(_delta)

func _transitions(_delta : float) -> void:
	if player.sprite.frame != 2:
		return
	if not player.is_grounded and player.vel.y > -.001:
		player.early_fall = false
		state_machine.transition_to("Fall")
	elif player.check_jump() or not player.is_grounded:
		state_machine.transition_to("Jump")
	elif not player.is_grounded:
		return
	if player.input_his.current[0].x == .0:
		state_machine.transition_to("Idle")
	elif player.input_his.current[0].x != .0:
		state_machine.transition_to("Move")