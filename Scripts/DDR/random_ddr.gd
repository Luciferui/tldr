extends SuperDDR

@export var inputRange : int = 5
@export var RelatedPlayer : Player

func _ready() -> void:
	generateRandomInputs()
	currentInput = InputList[0]

func generateRandomInputs():
	for a in range(inputRange):
		InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
	
func validateInput():
	playerInputs.append(InputList[0])
	InputList = InputList.slice(1)
	currentInput = InputList[0]
	InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
	$HBoxContainer.display_combo_queue(InputList)

func validateCombo():
	var comboLength := playerInputs.size()
	playerInputs = []
	if comboLength > 3:
		pass # Appeler les spells par le joueur
	
