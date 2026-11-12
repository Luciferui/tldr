## Classe de base abstraite représentant un état dans la machine à états.
class_name State
extends Node

## Appelé lors de l'entrée dans cet état.
func enter() -> void:
	pass

## Appelé lors de la sortie de cet état vers un nouvel état.
func exit(_new_state: State = null) -> void:
	pass

## Traite les événements d'entrée utilisateur. Retourne un nouvel état ou null.
func process_input(_event: InputEvent) -> State:
	return null

## Traite la frame de rendu (process standard). Retourne un nouvel état ou null.
func process_frame(_delta: float) -> State:
	return null

## Traite la frame de physique (process physique). Retourne un nouvel état ou null.
func process_physics(_delta: float) -> State:
	return null
