extends SStateMachine

onready var player := parent as Player

func _ready() -> void:
	add_state("cooled")
	add_state("burning")
	call_deferred("set_state", states.cooled)

func _state_logic(delta : float) -> void:
	if state == states.burning:
		if Input.is_action_pressed("push_metal"):
			pass

func _get_transition(delta : float) -> int:
	match state:
		states.cooled:
			return 0
		states.burning:
			return 0
		_: return -1

func _enter_state(new_state : int, old_state : int) -> void:
	match new_state:
		states.cooled:
			player.label.text = "Cooled"
		states.burning:
			player.label.text = "Burning"

#func _exit_state(old_state, _new_state):
#	match old_state:
