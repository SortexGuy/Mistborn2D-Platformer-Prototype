extends SStateMachine

onready var player := parent as Player
var heat_off : bool = false

func _ready() -> void:
	add_state("cooled")
	add_state("burning")
	add_state("heated")
	call_deferred("set_state", states.cooled)

func _state_logic(delta : float) -> void:
	if state != states.cooled:
		if Input.is_action_just_released("burn_metal") and state == states.heated:
			while not Input.is_action_pressed("burn_metal") and not heat_off:
				yield(get_tree().create_timer(1.0, false), "timeout")
				heat_off = true
		if Input.is_action_pressed("push_metal"):
			var point : Vector2 = (player.metal_detector._check_m_closest_p())
			player.vel += player.push_point(point, delta, state == states.heated)
			player.pushing = true
		elif player.pushing == true: player.pushing = false

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
			if Input.is_action_just_pressed("burn_metal"):
				return states.heated
			return -1
		states.heated:
			if Input.is_action_pressed("cool_metal"):
				return states.cooled
			if heat_off:
				return states.burning
			return -1
		_: return -1

func _enter_state(new_state : int, old_state : int) -> void:
	match new_state:
		states.cooled:
			player.metal_detector.heated = false
			player.metal_detector.burning = false
			player.label.text = "Cooled"
		states.burning:
			player.metal_detector.heated = false
			player.metal_detector.burning = true
			player.label.text = "Burning"
		states.heated:
			player.metal_detector.heated = true
			player.label.text = "Heated"

func _exit_state(old_state, _new_state):
	match old_state:
		states.heated:
			if heat_off: heat_off = false
