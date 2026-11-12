## État de douleur / étourdissement (hitstun) du joueur suite à une attaque reçue.
## Applique le recul (knockback) et amortit la vitesse jusqu'à expiration du temps de stun.
class_name PlayerPainState
extends PlayerState

@export var animation_name: String = "pain"
@export var knockback_force: float = 300.0
@export var hurtbox: PlayerHurtbox
@export var idle_state: State

var stun_finished: bool = false
var frame_count : int
var total_frame_count : int = 0

# Déclenche l'animation de douleur et conserve l'orientation
func enter() -> void:
	stun_finished = false
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip

## Calcule et applique le vecteur de recul résultant de l'attaque
func apply_knockback(attack : AttackData, pos : Vector2, orientation:int) -> void:
	player.velocity = attack.absolute_knockback + attack.orientation_knockback * orientation + (player.position - pos)*attack.relative_knockback_factor

# Réinitialise la durée totale de stun lors de la sortie de l'état
func exit(new_state: State = null) -> void:
	super.exit(new_state)
	total_frame_count = 0

# Indique la fin du stun si l'animation de douleur se termine
func _on_animation_finished() -> void:
	if player.sprite.animation == animation_name:
		stun_finished = true

## Ajoute un nombre de frames de stun si supérieur au stun restant
func apply_stun_time(time : int) ->void:
	total_frame_count = max(total_frame_count - frame_count, time)
	frame_count = 0

# Amortit la vitesse de recul (friction) et repasse en idle lorsque le stun est terminé
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	player.velocity = 0.95*player.velocity
	if stun_finished:
		return idle_state
	frame_count +=1
	if frame_count >= total_frame_count :
		stun_finished = true
		frame_count = 0
	return null
