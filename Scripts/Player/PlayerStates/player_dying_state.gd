## État critique / mourant du joueur : fige le mouvement horizontal, joue l'animation de détresse
## et émet le signal 'currently_dying' pendant que le contrôleur de sauvetage (Rescue) s'exécute.
class_name PlayerDyingState
extends PlayerState

@export var animation_name: StringName = &"dying"
signal currently_dying

# Immobilise le joueur, joue l'animation critique et signale l'état au système
func enter() -> void:
	player.velocity.x = 0.0
	player.sprite.play(animation_name)
	currently_dying.emit()

# Bloque les entrées utilisateur durant cet état
func process_input(_event: InputEvent) -> State:
	return

# Maintient le joueur immobile horizontalement tout en appliquant la gravité
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	player.velocity.x = 0.0
	return

# Sortie de l'état critique (en cas de sauvetage réussi)
func exit(new_state: State = null) -> void:
	super.exit(new_state)
	return
