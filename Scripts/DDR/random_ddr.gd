extends SuperDDR

@export var inputRange : int = 5
@export var RelatedPlayer : Player

func _ready() -> void:
	if RelatedPlayer.player_id % 2 == 0:
		self.position = Vector2(-220, 150)
		usedInput = ["p1_jump", "p1_down", "p1_right", "p1_left"]
	else:
		self.position = Vector2(220, 150)
		usedInput = ["p2_jump", "p2_down", "p2_right", "p2_left"]
	generateRandomInputs()
	$HBoxContainer.display_combo_queue(InputList)
	currentInput = InputList[0]
	$Counter.text = "0"

func generateRandomInputs():
	for a in range(inputRange):
		InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
func validateInput():
	playerInputs.append(InputList[0])
	$Counter.text = str(playerInputs.size())
	InputList = InputList.slice(1)
	currentInput = InputList[0]
	InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
	$HBoxContainer.display_combo_queue(InputList)
	print("display")

func validateCombo():
	var comboLength := playerInputs.size()
	playerInputs = []
	if comboLength > 3:
		pass # Appeler les spells par le joueur
		$Counter.text = "0"
	
func failCombo():
	playerInputs = []
	$Counter.text = str(playerInputs.size())
