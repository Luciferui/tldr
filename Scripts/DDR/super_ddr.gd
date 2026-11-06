extends Node
class_name SuperDDR

@export var cursor: InputCursor  # à assigner dans l'inspecteur (optionnel)

var finishInput : String = "p1_endcombo"
var currentInput : String

var usedInput : Array[String] = ["p1_jump", "p1_down", "p1_right", "p1_left"]
var playerInputs : Array[String] = []
var InputList : Array[String] = []

func _physics_process(_delta: float) -> void:
	for action in usedInput:
		if Input.is_action_just_pressed(action):
			if action == currentInput:
				validateInput()
				if cursor:
					cursor.play_success()
			else:
				failCombo()
				if cursor:
					cursor.play_fail()

	if Input.is_action_just_pressed(finishInput):
		validateCombo()

func failCombo():
	pass

func validateInput():
	# change currentInput, playerInputs
	pass

func validateCombo():
	# reset quoi qu'il arrive et traite si ça a marché
	pass
