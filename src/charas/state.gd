extends Node
class_name State

var state_machine : NStateMachine

func handle_input(_event : InputEvent) -> void:
	pass

func update(_delta : float) -> void:
	pass

func physics_update(_delta : float) -> void:
	pass

func enter(_msg : Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func _transitions(_delta : float) -> void:
	pass
