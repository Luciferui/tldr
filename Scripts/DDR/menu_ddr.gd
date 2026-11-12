# Variante du système DDR adaptée aux menus de sélection (validation d'options par combinaisons de touches).
extends SuperDDR

var position : int = 0
var playerFinishedCombo : bool = false
@export var button_ddr_count := 3
@export var inputRange : int = 6
@export var missed_ddr_duration_frame : int = 15   # Durée de l'affichage rouge en cas d'erreur (frames)
@export var success_ddr_duration_frame : int = 12  # Durée de l'affichage vert en cas de succès (frames)
@export var finish_key_hint: Texture2D  # Texture d'indice pour la touche de validation du combo
@export var hint_size: Vector2 = Vector2(48, 48)
@export var hint_offset: Vector2 = Vector2(0, 0)  # Décalage d'affichage de l'indice
@export var hint_margin: float = 8.0

var finish_hint: TextureRect
var total_input = 0

const BORDER_BLUE  := Color(0.0, 0.4, 1.0)
const BORDER_RED   := Color(1.0, 0.0, 0.0)
const BORDER_GREEN := Color(0.17, 1.0, 0.447, 1.0)

var shader_code : Shader = load("res://Scripts/Player/blue_filter.gdshader")
var border_material : ShaderMaterial
var default_material : Material
var FrameSprite : Sprite2D

var border_frames_left : int = 0

# Initialise le cadre, le shader de bordure et génère la première séquence
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
	_create_finish_hint()

# Décrémente la durée des effets colorés de bordure	
func _physics_process(delta: float) -> void:
	super(delta)
	if border_frames_left > 0:
		border_frames_left -= 1
		if border_frames_left == 0:
			FrameSprite.material = default_material

# Remplit la file d'attente d'entrées avec des touches aléatoires
func generateRandomInputs() -> void:
	for a in range(inputRange):
		InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
		
# Valide la touche pressée, avance la file et vérifie si le combo est prêt
func validateInput():
	playerInputs.append(InputList[0])
	InputList = InputList.slice(1)
	currentInput = InputList[0]
	InputList.append(usedInput[randi_range(0, usedInput.size()-1)])
	total_input = playerInputs.size()
	
	if total_input >= button_ddr_count:
		_set_border_color(BORDER_GREEN)
		if cursor: cursor.start_ready_pulse()
	else:
		FrameSprite.material = default_material
		if cursor: cursor.stop_ready_pulse()
	
	_set_finish_hint(total_input >= button_ddr_count)
	refresh_display()

# Confirme le combo si le nombre de touches requis est atteint et émet le signal
func validateCombo():
	if total_input >= button_ddr_count:
		emit_signal("pressed")
	playerInputs = []
	total_input = 0
	refresh_display()
	if cursor: cursor.stop_ready_pulse()
	_set_finish_hint(false)

# Met à jour les conteneurs d'icônes et le compteur textuel
func refresh_display() -> void:
	$HBoxContainer.display_combo_queue(InputList)
	$Counter.text = str(total_input)

# Gère l'erreur de saisie : bordure rouge et réinitialisation de la séquence accumulée
func failCombo() -> void:
	if playerInputs.size() > 0:
		_set_border_color(BORDER_RED)
		border_frames_left = missed_ddr_duration_frame
		playerInputs = []
		total_input = 0
		refresh_display()
		if cursor: 
			cursor.stop_ready_pulse()
			cursor.play_fail()
		_set_finish_hint(false)

# Modifie la couleur de la bordure via le shader
func _set_border_color(color: Color) -> void:
	border_material.set_shader_parameter("replace_color", color)
	FrameSprite.material = border_material

# Instancie et positionne l'indicateur visuel de touche finale
func _create_finish_hint() -> void:
	finish_hint = TextureRect.new()
	finish_hint.name = "FinishHint"
	finish_hint.texture = finish_key_hint
	finish_hint.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	finish_hint.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	finish_hint.custom_minimum_size = hint_size
	finish_hint.size = hint_size
	finish_hint.position = hint_offset
	finish_hint.visible = false
	add_child(finish_hint)
	_place_finish_hint()

# Affiche ou masque l'indicateur de touche finale
func _set_finish_hint(state: bool) -> void:
	if finish_hint:
		finish_hint.visible = state

# Positionne l'indicateur à droite de la bordure du DDR
func _place_finish_hint() -> void:
	var border_rect := FrameSprite.get_rect()  # Rectangle local du sprite
	var border_pos := FrameSprite.position
	var scl := FrameSprite.scale
	var right_edge := border_pos.x + (border_rect.position.x + border_rect.size.x) * scl.x
	var center_y := border_pos.y + (border_rect.position.y + border_rect.size.y / 2.0) * scl.y
	finish_hint.position = Vector2(right_edge + hint_margin, center_y - hint_size.y / 2.0) + hint_offset
