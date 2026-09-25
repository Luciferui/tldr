class_name StateMachine
extends Node
##Classe abstraite statemachine [br]
##init, change_state(new_state), process_input(event), process_frame(delta), process_physics(delta)

@export var starting_state: PlayerState
@export var pain_state : PlayerState
var current_state: State

func init() -> void:
	change_state(starting_state)

func change_state(new_state: State) -> void:
	#change d'état : exit de l'ancien puis enter du nouveau
	if current_state:
		current_state.exit(new_state)
	current_state = new_state
	current_state.enter()
	
func take_stun(framecount : int) -> void:
	pain_state.apply_stun_time(framecount)
	if not current_state==pain_state and framecount >0:
		change_state(pain_state)
		
func override_state(state : PlayerState) ->void:
	##change d'état sans poser de questions. idée de Marcel
	change_state(state)

func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	#new_state si changement, null sinon
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	#new_state si changement, null sinon
	if new_state:
		change_state(new_state)

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	#new_state si changement, null sinon
	if new_state:
		change_state(new_state)
