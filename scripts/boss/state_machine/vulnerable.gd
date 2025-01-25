extends Boss_State

class_name VulnerableState

@export var duration: float = 5.0  # Duration of the state in seconds
var remaining_time: float

func transition():
	remaining_time -= get_process_delta_time()  # Reduce remaining time
	if remaining_time <= 0:
		print("Transitioning to the next state")
		var next_state = "Follow" if randi() % 2 == 0 else "Dash"
		get_parent().change_state(next_state)


func enter():
	print("boss is now vulnerable")
	remaining_time = duration

func exit():
	print("boss is not vulnerable")
