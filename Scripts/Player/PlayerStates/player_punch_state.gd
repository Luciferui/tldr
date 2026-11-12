## Variante d'état d'attaque pour le coup de poing standard du joueur.
class_name PlayerPunchState
extends PlayerAttackState

# Configure la durée en frames et l'animation spécifique à ce coup
func enter() -> void :
	super.enter()
	totalFrameCount = 120
	animation_name = "fall"
