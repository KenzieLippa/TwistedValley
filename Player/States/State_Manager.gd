extends Node
class_name StateManager
var states : Dictionary
#here we are using the other scripts to call names
func _init():
	#initialize a dictionary
	states = {
		"idle": IdleState,
		"run": RunState
	}

func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	else:
		printerr("No state ", state_name, " Exists")
