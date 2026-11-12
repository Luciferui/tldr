# Contrôleur de la phase de sauvetage (Rescue) : lorsqu'un joueur subit trop de dégâts,
# il doit valider un nombre d'inputs DDR équivalent à ses points de vie dans un temps imparti pour survivre.
extends Node

signal rescue_failed(loser: Player)

# Temps limite accordé pour réussir le sauvetage (en secondes)
@export var time_limit: float = 5.0

var shader_code: Shader  = preload("res://Scripts/Player/blue_filter.gdshader")

@onready var player: Player = get_parent() as Player
@onready var dying: PlayerDyingState = $"../StateMachine/Dying"
@onready var idle: PlayerState = $"../StateMachine/Idle"
@onready var fall: PlayerState = $"../StateMachine/Fall"
var ddr: RandomDDR
var DDCounter : RichTextLabel

var required_inputs: int
var input_counter: int
var rescue_active: bool = false
var failed: bool = false
var deadline_ms: int = 0

func _ready() -> void:
	ddr = player.get_node("Ddr")
	DDCounter = ddr.get_node("DeathItems").get_node("DDHealthCounter")

# Déclenche la phase critique de sauvetage pour le joueur
func begin_rescue() -> bool:
	if player.ddhealth == 0:
		return false
	if rescue_active or failed:
		return false
	rescue_active = true

	ddr.playerInputs = [] # Réinitialise les entrées du joueur

	deadline_ms = Time.get_ticks_msec() + int(time_limit * 1000)
	player.statemachine.override_state(dying)
	required_inputs = player.ddhealth

	start_horloge(time_limit)

	flip_ddr_spell_visible()

	DDCounter.text = str(required_inputs)
	return true

# Met à jour le chronomètre et gère les effets visuels (assombrissement et clignotement)
func _process(_delta: float) -> void:
	if not rescue_active:
		return
	var remaining := maxf(0.0, (deadline_ms - Time.get_ticks_msec()) / 1000.0)
	if remaining <= 0.0:
		_fail()
	else: # Assombrit le sprite et fait clignoter le cadre du DDR
		apply_dark_filter(Color(1., 1., 1., 1.), (time_limit-remaining)/time_limit, $"../Sprite")
		if remaining - int(remaining) < 0.1:
			apply_dark_filter(Color(1., 1., 1., 1.), 0, $"../Ddr/GreekKeyRectangleFrameGreekBorderVector2317864614", 0.8)
		else:
			apply_dark_filter(Color("639bff"), (time_limit-remaining)/time_limit, $"../Ddr/GreekKeyRectangleFrameGreekBorderVector2317864614", 0.8)
		
# Bascule l'affichage entre l'interface standard des sorts et celle du sauvetage			
func flip_ddr_spell_visible():
	ddr.get_node("SpellReady").visible = !ddr.get_node("SpellReady").visible
	ddr.get_node("SpellHold").visible = !ddr.get_node("SpellHold").visible
	ddr.get_node("DeathItems").visible = !ddr.get_node("DeathItems").visible
	ddr.get_node("Counter").visible = !ddr.get_node("Counter").visible
	ddr.get_node("FlameSprite").visible = !ddr.get_node("FlameSprite").visible

# Notifié à chaque frappe d'input valide dans le DDR pendant le sauvetage
func ddr_input_changed() -> void:
	if not rescue_active:
		return
		
	if Time.get_ticks_msec() >= deadline_ms:
		_fail()
		return
	
	input_counter += 1
		
	DDCounter.text = str(required_inputs-input_counter)
	if input_counter >= required_inputs:
		_succeed()
		
# Succès du sauvetage : réduit les dégâts de moitié et rétablit l'état du joueur		
func _succeed():
	rescue_active = false
	player.ddhealth = floori(player.ddhealth / 2.0)
	input_counter = 0
	
	ddr.playerInputs = []
	ddr.total_input = 0
	ddr.refresh_display()
	player.get_node("DDHealthDisplayer").update_ddhealth(player.ddhealth)
	
	flip_ddr_spell_visible()
	$"../Horloge".visible = false
	if player.player_id%2 == 0:
		player.sprite.material = null
	else:
		player.apply_blue_filter(player.get_node("Sprite"))
	
	player.statemachine.override_state(idle if player.is_on_floor() else fall)

# Échec du sauvetage : le joueur perd le round
func _fail() -> void:
	rescue_active = false
	failed = true
	rescue_failed.emit(player) # Notifie le gestionnaire de niveau pour lancer le game over

# Démarre l'animation de compte à rebours de l'horloge
func start_horloge(animation_time: float):
	$"../Horloge".visible = true
	$"../Horloge/AnimationPlayer".play("Rotation")
	$"../Horloge/AnimationPlayer".speed_scale = 1/animation_time

# Applique un filtre d'assombrissement via shader sur un sprite
func apply_dark_filter(target_color: Color, rate: float, sprite: Node2D, tolerance: float = 0.5) -> void:
	var mat = ShaderMaterial.new()
	mat.shader = shader_code
	
	mat.set_shader_parameter("target_color", target_color) # Couleur cible à modifier
	mat.set_shader_parameter("replace_color", Color(1-rate, 1-rate, 1-rate, 1.0)) # Couleur assombrie
	mat.set_shader_parameter("tolerance", tolerance) # Tolérance de détection
	
	sprite.material = mat
	
