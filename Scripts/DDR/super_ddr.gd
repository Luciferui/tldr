extends Node
class_name SuperDDR

var finishInput : String = "endcombo"
var currentInput : String

var usedInput : Array[String] = ["up", "down", "right", "left", "lightatk", "heavyatk"]
var playerInputs : Array[String] = []
var InputList : Array[String] = []

func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(currentInput):
		validateInput()
	if Input.is_action_just_pressed(finishInput):
		validateCombo()


func validateInput():
	# change currentInput, playerInputs
	pass

func validateCombo():
	# reset quoi qu'il arrive et traite si ça a marché
	pass
