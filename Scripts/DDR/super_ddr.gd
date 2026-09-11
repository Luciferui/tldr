extends Node
class_name SuperDDR

var finishInput : String = "endcombo"
var currentInput : String

var usedInput : Array[String] = ["jump", "down", "right", "left"]#, "lightatk", "heavyatk"]
var playerInputs : Array[String] = []
var InputList : Array[String] = []

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
		
	for action in usedInput:
		if Input.is_action_just_pressed(action):
			if action == currentInput:
				validateInput()
			else:
				failCombo()
				
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
