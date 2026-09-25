extends SuperDDR

@export var inputRange : int = 5
@export var RelatedPlayer : Player

func _ready() -> void:
	# Gère les deux joueurs
	if RelatedPlayer.player_id % 2 == 0:
		self.position = Vector2(-220, 150)
		usedInput = ["p1_jump", "p1_down", "p1_right", "p1_left"]
	else:
		self.position = Vector2(220, 150)
		usedInput = ["p2_jump", "p2_down", "p2_right", "p2_left"]
	# Init
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

func validateCombo():
	var comboLength := playerInputs.size()
	playerInputs = []
	for i in range(len(DataManager.spellChoice[RelatedPlayer.player_id]), 0, -1):
		if comboLength > DataManager.spellChoice[RelatedPlayer.player_id][i].required_combo: #DDR Cost
			RelatedPlayer.holdSpell = DataManager.spellChoice[RelatedPlayer.player_id][i].id # Spell Id
		
	
func failCombo():
	playerInputs = []
	$Counter.text = str(playerInputs.size())
