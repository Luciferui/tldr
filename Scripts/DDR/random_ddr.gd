extends SuperDDR
class_name RandomDDR

@export var inputRange : int = 6
@export var RelatedPlayer : Player

var total_input = 0

# Bordure du DDR
const BORDER_BLUE  := Color(0.0, 0.4, 1.0)
const BORDER_RED   := Color(1.0, 0.0, 0.0)
const BORDER_GREEN := Color(0.173, 0.474, 1.0, 1.0) #On en met pas en vert pour l'instant
@export var missed_ddr_duration_frame : int = 15   # durée du rouge (30 frames ≈ 0,5 s à 60 Hz)
@export var success_ddr_duration_frame : int = 12  # durée du vert

var shader_code : Shader = load("res://Scripts/Player/blue_filter.gdshader")
var border_material : ShaderMaterial
var default_material : Material
var border_frames_left : int = 0
var FrameSprite : Sprite2D


func _ready() -> void:
	# init du cadre Ddr
	FrameSprite = $GreekKeyRectangleFrameGreekBorderVector2317864614
	default_material = FrameSprite.material
	border_material = ShaderMaterial.new()
	border_material.shader = shader_code
	border_material.set_shader_parameter("target_color", BORDER_BLUE)
	border_material.set_shader_parameter("tolerance", 0.5)
	
	# Gère le emplacements et les deux joueurs
	if RelatedPlayer.player_id % 2 == 0:
		self.position = Vector2(-220, 158)
		usedInput = ["p1_jump", "p1_down", "p1_right", "p1_left", "p1_light", "p1_heavy"]
		finishInput = "p1_endcombo"
		$Counter.position = Vector2(340, -245)
		$FlameSprite.position = Vector2(1110, 8)
		$SpellReady.position = Vector2(-950,-458)
		$SpellHold.position = Vector2(-830, -330)
	else:
		self.position = Vector2(220, 158)
		usedInput = ["p2_jump", "p2_down", "p2_right", "p2_left", "p2_light", "p2_heavy"]
		finishInput = "p2_endcombo"
		$Counter.position = Vector2(-1860, -245)
		$FlameSprite.position = Vector2(-1100, 8)
		$SpellReady.position = Vector2(-60, -458)
		$SpellHold.position = Vector2(60, -330)
	
	# Init Ddr
	generateRandomInputs()
	$HBoxContainer.display_combo_queue(InputList)
	currentInput = InputList[0]
	$Counter.text = "0"
	
	# Init des spell cast
	for spell in DataManager.spellChoice[RelatedPlayer.player_id]:
		var icon = TextureRect.new()
		icon.texture = spell.icon
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(256, 256) # Ajustez la taille voulue en pixels
		icon.custom_maximum_size = Vector2(256, 256) # Ajustez la taille voulue en pixels
		
		var sat_shader = load("res://Scripts/Player/sat_exp_tint.gdshader")
	
		var mat = ShaderMaterial.new()
		mat.shader = sat_shader
		mat.set_shader_parameter("exposure", 1.)
		mat.set_shader_parameter("saturation", 0.0)
		icon.material = mat
		$SpellReady.add_child(icon)
	
	# Cache les sprite des spellHold
	for i in range(3):
		display_hold_spell(i, false)

func _physics_process(delta: float) -> void:
	super(delta)
	if border_frames_left > 0:
		border_frames_left -= 1
		if border_frames_left == 0:
			reset_border()

func generateRandomInputs() -> void:
	for a in range(inputRange):
		InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
		
func validateInput() -> void:
	apply_green_filter()
	border_frames_left = success_ddr_duration_frame
	
	playerInputs.append(InputList[0])
	InputList = InputList.slice(1)
	currentInput = InputList[0]
	InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
	
	total_input = playerInputs.size()
	RelatedPlayer.get_node("RescueController").ddr_input_changed()
	
	refresh_display()

func refresh_display() -> void:
	# Hbox liste des inputs
	$HBoxContainer.display_combo_queue(InputList)
	
	
	#Affichage textuel
	var p_id = RelatedPlayer.player_id
	$Counter.text = str(total_input)
	if total_input >= DataManager.spellChoice[p_id][2].required_combo:
		$Counter.add_theme_color_override("font_color", Color(0.187, 0.13, 0.2, 1.0))
		$FlameSprite.play("PurpleFlame")
	else: if total_input >= DataManager.spellChoice[p_id][1].required_combo:
		$Counter.add_theme_color_override("font_color", Color(0.085, 0.217, 0.34, 1.0))
		$FlameSprite.play("BlueFrame")
	else: if total_input >= DataManager.spellChoice[p_id][0].required_combo:
		$Counter.add_theme_color_override("font_color", Color(0.31, 0.136, 0.136, 1.0))
		$FlameSprite.play("YellowFlame")
	else:
		$Counter.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0, 1.0))
		$FlameSprite.play("default")
	
	# Affichage des spell possibles à activer (saturation)
	for i in range(len(DataManager.spellChoice[RelatedPlayer.player_id])):
		if total_input >= DataManager.spellChoice[RelatedPlayer.player_id][i].required_combo: #DDR Cost
			$SpellReady.get_child(i).material.set_shader_parameter("saturation", 1.0)
		else:
			$SpellReady.get_child(i).material.set_shader_parameter("saturation", 0.0)
	
func validateCombo() -> void:
	# Parcours les spells et met le plus grand dans set_hold
	var player_spell_id = -1
	for i in range(len(DataManager.spellChoice[RelatedPlayer.player_id])):
		var spell = DataManager.spellChoice[RelatedPlayer.player_id][i]
		if total_input >= spell.required_combo:
			RelatedPlayer.set_hold(spell.id) # écrase si plus petit déjà envoyé
			player_spell_id = i
	playerInputs = []
	total_input = 0
	refresh_display()
	
	for i in range(3):
		display_hold_spell(i, i==player_spell_id)
		print(i, "  ", i == player_spell_id)
		
			
func display_hold_spell(player_spell_id : int, state: bool) -> void:
	$SpellHold.get_node("Spell"+str(player_spell_id)).get_node("Spell"+str(player_spell_id)).visible = state


func failCombo() -> void:
	if playerInputs.size() > 0:
		apply_red_filter()
		border_frames_left = missed_ddr_duration_frame
		playerInputs = []
		total_input = 0
		refresh_display()

func _set_border_color(color: Color) -> void:
	border_material.set_shader_parameter("replace_color", color)
	FrameSprite.material = border_material

func apply_red_filter() -> void:
	_set_border_color(BORDER_RED)

func apply_green_filter() -> void:
	_set_border_color(BORDER_GREEN)

func reset_border() -> void:
	FrameSprite.material = default_material  # retour à la couleur d'origine (bleue)
