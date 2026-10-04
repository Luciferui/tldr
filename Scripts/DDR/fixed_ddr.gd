extends SuperDDR

var position : int = 0
var playerFinishedCombo : bool = false

@export var fixedInputList : Array[String]

func _ready() -> void:
	InputList = fixedInputList
	currentInput = InputList[0]
	usedInput = ["p1_jump", "p1_down", "p1_right", "p1_left", "p1_light", "p1_heavy",
				 "p2_jump", "p2_down", "p2_right", "p2_left", "p2_light", "p2_heavy"]


func validateInput():
	if position != InputList.size():
		position  += 1
		if position != InputList.size():
			currentInput = InputList[position]
		else:
			currentInput = "--ComboEnded--"
	
	
func validateCombo():
	if position == InputList.size():
		emit_signal("pressed")
		print("startpressed")
		# Appeler l'action correspondante
	position = 0
	
func failCombo():
	position = 0
	currentInput = InputList[position]
	
	
