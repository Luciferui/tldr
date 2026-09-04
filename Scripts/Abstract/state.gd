class_name State
extends Node
##Classe abstraite state [br]
##enter, exit(new_state), process_input(event), process_frame(delta), process_physics(delta)

func enter() -> void:
	pass

func exit(new_state: State = null) -> void:
	pass

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func process_physics(delta: float) -> State:
	return null
