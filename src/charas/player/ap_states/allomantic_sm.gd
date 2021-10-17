extends SStateMachine

onready var player := parent as Player

func _ready() -> void:
	add_state("cooled")
	add_state("burning")
	call_deferred("set_state", states.cooled)

func _state_logic(delta : float) -> void:
	if state == states.burning:
		if Input.is_action_pressed("push_metal"):
			var point : Vector2 = (player.metal_detector._check_m_closest_p())
			player.vel += (player.global_position - point).normalized() * 40.0

func _input(event: InputEvent) -> void:
	pass

func _get_transition(delta : float) -> int:
	match state:
		states.cooled:
			if Input.is_action_pressed("burn_metal"):
				return states.burning
			return -1
		states.burning:
			if Input.is_action_pressed("cool_metal"):
				return states.cooled
			return -1
		_: return -1

func _enter_state(new_state : int, old_state : int) -> void:
	match new_state:
		states.cooled:
			player.metal_detector.burning = false
			player.label.text = "Cooled"
		states.burning:
			player.metal_detector.burning = true
			player.label.text = "Burning"

#func _exit_state(old_state, _new_state):
#	match old_state:
#		states.burning:
