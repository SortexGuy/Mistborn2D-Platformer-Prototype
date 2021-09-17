extends Node
class_name SStateMachine

onready var parent := get_parent()

var state : int = -1 setget set_state
var previous_state : int = -1
var states : Dictionary = {}

func _physics_process(delta : float) -> void:
	if state != -1:
		_state_logic(delta)
		var transition := _get_transition(delta)
		if transition != -1:
			set_state(transition)

func _state_logic(_delta : float) -> void:
	pass

func _get_transition(_delta : float) -> int:
	return -1

func _enter_state(_new_state : int, _old_state : int) -> void:
	pass

func _exit_state(_old_state : int, _new_state : int) -> void:
	pass

func set_state(new_state : int) -> void:
	previous_state = state
	state = new_state
	
	if previous_state != -1:
		_exit_state(previous_state, new_state)
	if new_state != -1:
		_enter_state(new_state, previous_state)

func add_state(state_name : String) -> void:
	states[state_name] = states.size()
