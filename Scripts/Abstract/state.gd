class_name State
extends Node
##Classe abstraite state [br]
##enter, exit(new_state), process_input(event), process_frame(delta), process_physics(delta)

func enter() -> void:
	pass

func exit(_new_state: State = null) -> void:
	pass

func process_input(_event: InputEvent) -> State:
	return null

func process_frame(_delta: float) -> State:
	return null

func process_physics(_delta: float) -> State:
	return null
