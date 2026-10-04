extends Node
class_name SuperDDR

var finishInput : String = "p1_endcombo"
var currentInput : String

var usedInput : Array[String] = ["p1_jump", "p1_down", "p1_right", "p1_left"]#, "lightatk", "heavyatk"]
var playerInputs : Array[String] = []
var InputList : Array[String] = []

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	for action in usedInput:
		if Input.is_action_just_pressed(action):
			print(action)
			if action == currentInput:
				validateInput()
			else:
				failCombo()
				
	if Input.is_action_just_pressed(finishInput):
		validateCombo()
		print("validate")

func failCombo():
	pass

func validateInput():
	# change currentInput, playerInputs
	pass

func validateCombo():
	# reset quoi qu'il arrive et traite si ça a marché
	pass
