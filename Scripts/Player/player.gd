class_name Player
extends CharacterBody2D
##Joueur controllable [br]

@onready var statemachine: StateMachine = $StateMachine
@onready var spellLauncher : SpellLauncher = $SpellLauncher
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var rescue_controller: Node = $RescueController

@export var player_id: int = 0
@export var left_action: StringName = &"p1_left"
@export var right_action: StringName = &"p1_right"
@export var jump_action: StringName = &"p1_jump"
@export var down_action: StringName = &"p1_down"
@export var heavy_attack_action: StringName = &"p1_heavy"
@export var light_attack_action: StringName = &"p1_light"
@export var spell_action: StringName = &"p1_spell"
@export var dodge_action: StringName = &"p1_dodge"
@export var opponent: Player
@export var sprite_faces_left: bool = false
@export var dying_threshold: int = 100

@export var shader_code: Shader  = preload("res://Scripts/Player/blue_filter.gdshader")
signal damage_changed(value: int)

func get_sprite_faces_left() -> bool:
	return sprite.flip_h

var ddhealth : int = 0

var holdSpell : int = -1

var match_over: bool = false


func get_hold(): 
	return holdSpell
func set_hold(hold: int): 
	holdSpell = hold
	
var can_dodge = true
func get_can_dodge() -> bool:
	return can_dodge
func set_can_dodge(x:bool) ->void :
	can_dodge = x

func _ready() -> void:
	statemachine.init()
	spellLauncher.init()
	if player_id % 2 == 1:
		apply_blue_filter($Sprite)

func _unhandled_input(event: InputEvent) -> void:
	if match_over or rescue_controller.rescue_active or rescue_controller.failed:
		return
	statemachine.process_input(event)
	spellLauncher.process_input(event)

func _process(delta: float) -> void:
	if match_over:
		return
	statemachine.process_frame(delta)
	if not rescue_controller.rescue_active and not rescue_controller.failed:
		spellLauncher.process_frame(delta)

func _physics_process(delta: float) -> void:
	
	statemachine.process_physics(delta)
	if not rescue_controller.rescue_active and not rescue_controller.failed:
		spellLauncher.process_physics(delta)
	move_and_slide()

func takeAttack(data: AttackData, attackerPos: Vector2,
		attackerOrientation: int) -> void:
	if match_over or rescue_controller.rescue_active or rescue_controller.failed:
		return

	ddhealth += data.damage
	$DDHealthDisplayer.update_ddhealt(ddhealth)
	damage_changed.emit(ddhealth)

	if ddhealth >= dying_threshold:
		rescue_controller.begin_rescue()
		return

	statemachine.take_attack(data, attackerPos, attackerOrientation)

func heal(x: int) -> void:
	ddhealth = maxi(0, ddhealth - x)
	damage_changed.emit(ddhealth)
	

func apply_blue_filter(sprite: AnimatedSprite2D) -> void:
	# 1. Créer un ShaderMaterial
	var mat = ShaderMaterial.new()
	mat.shader = shader_code
	
	# 2. Configurer les paramètres (Rouge -> Bleu)
	mat.set_shader_parameter("target_color", Color(1.0, 0.0, 0.0)) # Rouge à remplacer
	mat.set_shader_parameter("replace_color", Color(0.0, 0.4, 1.0)) # Nouveau bleu
	mat.set_shader_parameter("tolerance", 0.5) # Ajuster si le sprite a du shading/dégradé
	
	# 3. Appliquer le matériau au sprite du joueur 2 uniquement
	sprite.material = mat


	
