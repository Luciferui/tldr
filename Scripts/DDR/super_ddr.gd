## Classe de base pour les systèmes de saisie rythmique DDR (Dance Dance Revolution).
## Détecte les entrées du joueur, valide la concordance avec la touche attendue ou signale une erreur.
extends Node
class_name SuperDDR

@export var cursor: InputCursor  # Curseur visuel optionnel réagissant au succès/échec

var finishInput : String = "p1_endcombo"
var currentInput : String

var usedInput : Array[String] = ["p1_jump", "p1_down", "p1_right", "p1_left"]
var playerInputs : Array[String] = []
var InputList : Array[String] = []

# Vérifie à chaque tick physique si le joueur a pressé l'une des touches attendues ou la touche de fin
func _physics_process(_delta: float) -> void:
	for action in usedInput:
		if Input.is_action_just_pressed(action):
			if action == currentInput:
				validateInput()
				if cursor:
					cursor.play_success()
			else:
				failCombo()

	if Input.is_action_just_pressed(finishInput):
		validateCombo()

## Déclenché en cas de mauvaise touche pressée (à surcharger)
func failCombo():
	pass

## Déclenché lorsqu'une touche correcte est pressée (à surcharger)
func validateInput():
	pass

## Déclenché lorsque la touche de validation du combo est pressée (à surcharger)
func validateCombo():
	pass
