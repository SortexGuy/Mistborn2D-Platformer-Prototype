extends Resource
class_name InputHistory
# Historial para el input

var current : Array = [0, Vector2.ZERO, false]
var his_frames : int = 0

func update() -> void:
	var dir : Vector2 = Vector2(
		(-int(Input.is_action_pressed("move_left")) + 
		int(Input.is_action_pressed("move_right"))), .0)
	var jump : bool = Input.is_action_pressed("jump")
	
	if (dir != current[1]) or (jump != current[2]):
		current.clear()
		his_frames = 0
	
	his_frames += 1
	current = [his_frames, dir, jump]
