extends SuperDDR

var position : int = 0
var playerFinishedCombo : bool = false
@export var button_ddr_count := 3
@export var inputRange : int = 6
@export var missed_ddr_duration_frame : int = 15   # durée du rouge (30 frames ≈ 0,5 s à 60 Hz)
@export var success_ddr_duration_frame : int = 12  # durée du vert

var total_input = 0

const BORDER_BLUE  := Color(0.0, 0.4, 1.0)
const BORDER_RED   := Color(1.0, 0.0, 0.0)
const BORDER_GREEN := Color(0.17, 1.0, 0.447, 1.0)

var shader_code : Shader = load("res://Scripts/Player/blue_filter.gdshader")
var border_material : ShaderMaterial
var default_material : Material
var FrameSprite : Sprite2D

var border_frames_left : int = 0

func _ready() -> void:
	usedInput = ["p1_jump", "p1_down", "p1_right", "p1_left"]#, "p1_light", "p1_heavy"]
	FrameSprite = $Border
	
	default_material = FrameSprite.material
	border_material = ShaderMaterial.new()
	border_material.shader = shader_code
	border_material.set_shader_parameter("target_color", BORDER_BLUE)
	border_material.set_shader_parameter("tolerance", 0.5)
	
	generateRandomInputs()
	currentInput = InputList[0]
	refresh_display()
	
func _physics_process(delta: float) -> void:
	super(delta)
	if border_frames_left > 0:
		border_frames_left -= 1
		if border_frames_left == 0:
			FrameSprite.material = default_material

func generateRandomInputs() -> void:
	for a in range(inputRange):
		InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
		

func validateInput():
	playerInputs.append(InputList[0])
	InputList = InputList.slice(1)
	currentInput = InputList[0]
	InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
	total_input = playerInputs.size()
	
	if total_input > button_ddr_count:
		_set_border_color(BORDER_GREEN)
	else:
		FrameSprite.material = default_material
		
	refresh_display()
	
func validateCombo():
	if total_input >= 3:
		emit_signal("pressed")
	playerInputs = []
	total_input = 0
	refresh_display()
	
func refresh_display() -> void:
	$HBoxContainer.display_combo_queue(InputList)
	$Counter.text = str(total_input)
	
func failCombo() -> void:
	if playerInputs.size() > 0:
		_set_border_color(BORDER_RED)
		border_frames_left = missed_ddr_duration_frame
		playerInputs = []
		total_input = 0
		refresh_display()
	
func _set_border_color(color: Color) -> void:
	border_material.set_shader_parameter("replace_color", color)
	FrameSprite.material = border_material
	
