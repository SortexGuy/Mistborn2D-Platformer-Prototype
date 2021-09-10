extends PlayerState

func enter(_msg : Dictionary = {}) -> void:
	player.label.text = "Steel"

func _transitions(_delta : float) -> void:
	if player.current_metal == player.METALS.IRON:
		state_machine.transition_to("Iron")
