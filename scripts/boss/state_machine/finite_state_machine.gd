extends Node2D
class_name FiniteStateMachine

var current_state: Boss_State
var previous_state: Boss_State

func _ready():
	current_state = get_child(0) as Boss_State
	previous_state = current_state
	current_state.enter()


func change_state(state):
	print("Changing state to:", Boss_State)
	var new_state = find_child(state) as Boss_State
	if not new_state:
		print("State not found")
		return
	if current_state:
		current_state.exit()
	previous_state = current_state
	current_state = new_state
	print("New current state:", current_state)
	current_state.enter()
