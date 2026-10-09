extends SuperDDR

@export var inputRange : int = 6
@export var RelatedPlayer : Player
@export var shader_code : Shader

signal total_input_change (total: int) 
var total_input = 0
const BORDER_BLUE  := Color(0.0, 0.4, 1.0)
const BORDER_RED   := Color(1.0, 0.0, 0.0)
const BORDER_GREEN := Color(0.173, 0.474, 1.0, 1.0)

@export var missed_ddr_duration_frame : int = 30   # durée du rouge (30 frames ≈ 0,5 s à 60 Hz)
@export var success_ddr_duration_frame : int = 12  # durée du vert

var border_material : ShaderMaterial
var default_material : Material
var border_frames_left : int = 0
var sprite : Sprite2D

func _ready() -> void:
	sprite = $GreekKeyRectangleFrameGreekBorderVector2317864614
	default_material = sprite.material
	border_material = ShaderMaterial.new()
	border_material.shader = shader_code
	border_material.set_shader_parameter("target_color", BORDER_BLUE)
	border_material.set_shader_parameter("tolerance", 0.5)
	# Gère les deux joueurs
	if RelatedPlayer.player_id % 2 == 0:
		self.position = Vector2(-220, 150)
		usedInput = ["p1_jump", "p1_down", "p1_right", "p1_left", "p1_light", "p1_heavy"]
		finishInput = "p1_endcombo"
	else:
		self.position = Vector2(220, 150)
		usedInput = ["p2_jump", "p2_down", "p2_right", "p2_left", "p2_light", "p2_heavy"]
		finishInput = "p2_endcombo"
	# Init
	generateRandomInputs()
	$HBoxContainer.display_combo_queue(InputList)
	currentInput = InputList[0]
	$Counter.text = "0"

func _physics_process(delta: float) -> void:
	super(delta)
	if border_frames_left > 0:
		border_frames_left -= 1
		if border_frames_left == 0:
			reset_border()

func generateRandomInputs():
	for a in range(inputRange):
		InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
		
func validateInput():
	apply_green_filter()
	border_frames_left = success_ddr_duration_frame
	playerInputs.append(InputList[0])
	$Counter.text = str(playerInputs.size())
	total_input += 1
	total_input_change.emit(total_input)
	InputList = InputList.slice(1)
	currentInput = InputList[0]
	InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
	$HBoxContainer.display_combo_queue(InputList)

func validateCombo():
	var comboLength := playerInputs.size()
	playerInputs = []
	for i in range(len(DataManager.spellChoice[RelatedPlayer.player_id]), 0, -1):
		if comboLength >= DataManager.spellChoice[RelatedPlayer.player_id][i-1].required_combo: #DDR Cost
			RelatedPlayer.set_hold(DataManager.spellChoice[RelatedPlayer.player_id][i-1].id) # Spell Id
		
	
func failCombo():
	if playerInputs.size() > 0:
		apply_red_filter()
		border_frames_left = missed_ddr_duration_frame
	playerInputs = []
	$Counter.text = str(playerInputs.size())

func _set_border_color(color: Color) -> void:
	border_material.set_shader_parameter("replace_color", color)
	sprite.material = border_material

func apply_red_filter() -> void:
	_set_border_color(BORDER_RED)

func apply_green_filter() -> void:
	_set_border_color(BORDER_GREEN)

func reset_border() -> void:
	sprite.material = default_material  # retour à la couleur d'origine (bleue)
