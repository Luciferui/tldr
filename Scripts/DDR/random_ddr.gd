extends SuperDDR

@export var inputRange : int = 5

func _ready() -> void:
	generateRandomInputs()
	currentInput = InputList[0]

func generateRandomInputs():
	for a in range(inputRange):
		InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
	
func validateInput():
	playerInputs.append(InputList[0])
	InputList = InputList.slice(1)
	InputList.append(usedInput[randi_range(0, usedInput.size()-1)])	

func validateCombo():
	var comboLength := playerInputs.size()
	playerInputs = []
	if comboLength > 3:
		pass # Appeler les spells
	
