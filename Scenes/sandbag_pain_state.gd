## État de douleur / encaissement des dégâts du mannequin d'entraînement (Sandbag).
## Gère le hitstun subi avant de revenir automatiquement à l'état de repos (idle).
class_name SandbagPainState
extends State

@export var animation_name: String = "pain"
@export var knockback_force: float = 300.0
@export var hurtbox: PlayerHurtbox
@export var idle_state: State

var stun_finished: bool = false
var frame_count : int
var total_frame_count : int = 0
var sandbag : Sandbag

# Récupère la référence vers le mannequin propriétaire
func _ready() ->void:
	sandbag = owner as Sandbag

# Joue l'animation de douleur et réinitialise l'indicateur de stun
func enter() -> void:
	stun_finished = false
	sandbag.sprite.play(animation_name)

# Applique le recul (non utilisé sur le mannequin)
func apply_knockback(_attack : AttackData, _pos : Vector2, _orientation:int) -> void:
	pass

# Réinitialise le compteur de frames lors de la sortie de l'état
func exit(new_state: State = null) -> void:
	super.exit(new_state)
	total_frame_count = 0

func _on_animation_finished() -> void:
	pass

## Détermine la durée totale de stun restant si elle dépasse le stun actuel
func apply_stun_time(time : int) ->void:
	total_frame_count = max(total_frame_count - frame_count, time)
	frame_count = 0

# Applique la gravité, décompte le temps de stun et repasse en idle lorsque le stun s'achève
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	if not sandbag.is_on_floor():
		sandbag.velocity += sandbag.get_gravity() * delta	
	if stun_finished:
		return idle_state
	frame_count +=1
	if frame_count >= total_frame_count :
		stun_finished = true
		frame_count = 0
	return null
