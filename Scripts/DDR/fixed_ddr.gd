extends SuperDDR

var position : int = 0
var playerFinishedCombo : bool = false

func _ready() -> void:
	InputList = ["left", "right"] #la séquence qu'on veut pour ce bouton 
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
	
	
