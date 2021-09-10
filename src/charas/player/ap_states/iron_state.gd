extends PlayerState

func enter(_msg : Dictionary = {}) -> void:
	player.label.text = "Iron"

func _transitions(_delta : float) -> void:
	if player.current_metal == player.METALS.STEEL:
		state_machine.transition_to("Steel")
