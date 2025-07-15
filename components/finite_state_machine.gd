class_name FiniteStateMachine
extends RefCounted

signal state_changed(new_state: State)

var state: State


func change_state(new_state: State) -> void:
	if state:
		state.exit()
	
	if new_state:
		new_state.enter()
	
	state = new_state
	state_changed.emit(state)
