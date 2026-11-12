## Machine à états finis (FSM) générique gérant les transitions et le cycle de vie des états.
class_name StateMachine
extends Node

@export var starting_state: State
@export var pain_state : State
var current_state: State

# Initialise la machine à états avec l'état de départ.
func init() -> void:
	change_state(starting_state)

# Effectue la transition de l'état courant vers le nouvel état.
func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit(new_state)
	current_state = new_state
	current_state.enter()
	
# Applique le stun et le knockback d'une attaque reçue, puis bascule vers l'état de douleur si applicable.
func take_attack(attack : AttackData, attackerPos : Vector2, attackerOrientation : int) -> void:
	pain_state.apply_stun_time(attack.hitstun)
	pain_state.apply_knockback(attack, attackerPos, attackerOrientation)
	if not current_state==pain_state and attack.hitstun>0:
		change_state(pain_state)
		
## Force la transition directe vers un état sans vérification préalable.
func override_state(state : PlayerState) ->void:
	change_state(state)

# Délègue les entrées utilisateur à l'état actif et gère une éventuelle transition.
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

# Délègue le traitement de frame à l'état actif et gère une éventuelle transition.
func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)

# Délègue la physique à l'état actif et gère une éventuelle transition.
func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
