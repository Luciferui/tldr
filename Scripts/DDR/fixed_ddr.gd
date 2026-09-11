extends SuperDDR

var position : int = 0
var playerFinishedCombo : bool = false

@export var fixedInputList : Array[String]

func _ready() -> void:
	InputList = fixedInputList
	currentInput = InputList[0]


func validateInput():
	print(position)
	if position != InputList.size():
		position  += 1
		if position != InputList.size():
			currentInput = InputList[position]
		else:
			currentInput = "--ComboEnded--"
	
	
func validateCombo():
	print("validate")
	if position == InputList.size():
		emit_signal("pressed")
		# Appeler l'action correspondante
	position = 0
	
func failCombo():
	position = 0
	currentInput = InputList[position]
	print("failed")
	
	
