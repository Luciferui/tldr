## Système DDR en combat pour chaque joueur : gère la saisie de touches, l'incrémentation du combo,
## l'activation visuelle des sorts disponibles et le stockage du sort sélectionné (hold).
extends SuperDDR
class_name RandomDDR

@export var inputRange : int = 6
@export var RelatedPlayer : Player

var total_input = 0

# Couleurs de retour visuel pour la bordure du DDR
const BORDER_BLUE  := Color(0.0, 0.4, 1.0)
const BORDER_RED   := Color(1.0, 0.0, 0.0)
const BORDER_GREEN := Color(0.173, 0.474, 1.0, 1.0)
@export var missed_ddr_duration_frame : int = 15   # Durée de l'affichage rouge en cas d'erreur (frames)
@export var success_ddr_duration_frame : int = 12  # Durée de l'affichage vert en cas de succès (frames)

var shader_code : Shader = load("res://Scripts/Player/blue_filter.gdshader")
var border_material : ShaderMaterial
var default_material : Material
var border_frames_left : int = 0
var FrameSprite : Sprite2D

# Initialise l'interface, les touches de contrôle selon le joueur (P1/P2) et les icônes de sorts
func _ready() -> void:
	# Initialisation du cadre DDR
	FrameSprite = $GreekKeyRectangleFrameGreekBorderVector2317864614
	default_material = FrameSprite.material
	border_material = ShaderMaterial.new()
	border_material.shader = shader_code
	border_material.set_shader_parameter("target_color", BORDER_BLUE)
	border_material.set_shader_parameter("tolerance", 0.5)
	
	# Configuration des positions et des touches selon le joueur (P1 ou P2)
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
	
	# Initialisation de la file DDR
	generateRandomInputs()
	$HBoxContainer.display_combo_queue(InputList)
	currentInput = InputList[0]
	$Counter.text = "0"
	
	# Instanciation des icônes de sorts avec leur shader de désaturation initiale
	for spell in DataManager.spellChoice[RelatedPlayer.player_id]:
		var icon = TextureRect.new()
		icon.texture = spell.icon
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		icon.custom_minimum_size = Vector2(256, 256)
		icon.custom_maximum_size = Vector2(256, 256)
		
		var sat_shader = load("res://Scripts/Player/sat_exp_tint.gdshader")
	
		var mat = ShaderMaterial.new()
		mat.shader = sat_shader
		mat.set_shader_parameter("exposure", 1.)
		mat.set_shader_parameter("saturation", 0.0)
		icon.material = mat
		$SpellReady.add_child(icon)
	
	# Masque les indicateurs de sorts en réserve (hold)
	for i in range(3):
		display_hold_spell(i, false)

# Gère le retour au matériau par défaut après expiration du temps d'effet
func _physics_process(delta: float) -> void:
	super(delta)
	if border_frames_left > 0:
		border_frames_left -= 1
		if border_frames_left == 0:
			reset_border()

# Génère une série de touches aléatoires pour alimenter la file DDR
func generateRandomInputs() -> void:
	for a in range(inputRange):
		InputList.append(usedInput[randi_range(0, usedInput.size()-1)])

# Valide l'entrée correcte, avance la séquence et notifie le contrôleur de sauvetage
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

# Rafraîchit les icônes de file, la flamme de niveau de combo et la saturation du sort débloqué
func refresh_display() -> void:
	# Mise à jour de la file d'icônes
	$HBoxContainer.display_combo_queue(InputList)
	
	# Mise à jour du texte et de l'animation de flamme selon le palier atteint
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
	
	# Met en valeur uniquement le sort de plus haut niveau actuellement débloqué
	var spells = DataManager.spellChoice[RelatedPlayer.player_id]
	var best_spell_index := -1
	for i in range(len(spells)):
		if total_input >= spells[i].required_combo:
			best_spell_index = i

	for i in range(len(spells)):
		var sat := 1.0 if i == best_spell_index else 0.0
		$SpellReady.get_child(i).material.set_shader_parameter("saturation", sat)

# Stocke le sort le plus puissant débloqué dans la réserve du joueur et réinitialise le combo
func validateCombo() -> void:
	var player_spell_id = -1
	if RelatedPlayer.holdSpell == -1:
		for i in range(len(DataManager.spellChoice[RelatedPlayer.player_id])):
			var spell = DataManager.spellChoice[RelatedPlayer.player_id][i]
			if total_input >= spell.required_combo:
				RelatedPlayer.set_hold(spell.id)
				player_spell_id = i

	# Si aucun sort n'a été débloqué, on conserve le compteur intact
	if player_spell_id == -1:
		return

	playerInputs = []
	total_input = 0
	refresh_display()

	for i in range(3):
		display_hold_spell(i, i == player_spell_id)

# Affiche ou masque le visuel du sort stocké en réserve
func display_hold_spell(player_spell_id : int, state: bool) -> void:
	$SpellHold.get_node("Spell"+str(player_spell_id)).get_node("Spell"+str(player_spell_id)).visible = state

# Gère l'échec de frappe : réinitialise les inputs accumulés et déclenche le retour d'erreur
func failCombo() -> void:
	if playerInputs.size() > 0:
		apply_red_filter()
		border_frames_left = missed_ddr_duration_frame
		playerInputs = []
		total_input = 0
		refresh_display()
		if cursor:
			cursor.play_fail()

# Applique une teinte à la bordure
func _set_border_color(_color: Color) -> void:
	pass

# Applique la teinte rouge d'échec
func apply_red_filter() -> void:
	_set_border_color(BORDER_RED)

# Applique la teinte verte de réussite
func apply_green_filter() -> void:
	_set_border_color(BORDER_GREEN)

# Restaure le matériau d'origine de la bordure
func reset_border() -> void:
	FrameSprite.material = default_material
