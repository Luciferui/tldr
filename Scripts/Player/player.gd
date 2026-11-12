## Personnage joueur contrôlable : orchestre la machine à états, le DDR, les sorts,
## la gestion des dégâts (DDHealth), les attaques et le déclenchement du sauvetage.
class_name Player
extends CharacterBody2D

@onready var statemachine: StateMachine = $StateMachine
@onready var spellLauncher : SpellLauncher = $SpellLauncher
@onready var sprite: AnimatedSprite2D = $Sprite
@onready var rescue_controller: Node = $RescueController
@onready var hurt_sound: AudioStreamPlayer = $HurtSound
@onready var ddr: RandomDDR = $Ddr

@export var player_id: int = 0
@export var left_action: StringName = &"p1_left"
@export var right_action: StringName = &"p1_right"
@export var jump_action: StringName = &"p1_jump"
@export var down_action: StringName = &"p1_down"
@export var heavy_attack_action: StringName = &"p1_heavy"
@export var light_attack_action: StringName = &"p1_light"
@export var spell_action: StringName = &"p1_spell"
@export var dodge_action: StringName = &"p1_dodge"
@export var opponent: CharacterBody2D
@export var sprite_faces_left: bool = false
@export var dying_threshold: int = 100

@export var shader_code: Shader  = preload("res://Scripts/Player/blue_filter.gdshader")

signal ddhealth_changed # Émis lors d'une variation de vie (utilisé pour moduler les basses musicales)
signal hit_received(attack: AttackData) # Émis lorsqu'un coup touche le joueur

# Indique si le sprite est orienté vers la gauche
func get_sprite_faces_left() -> bool:
	return sprite.flip_h

var ddhealth : int = 0

var holdSpell : int = -1

var match_over: bool = false

# Accesseur pour le sort actuellement en réserve (hold)
func get_hold(): 
	return holdSpell
func set_hold(hold: int): 
	holdSpell = hold

# Gestion de la disponibilité de l'esquive
var can_dodge = true
func get_can_dodge() -> bool:
	return can_dodge
func set_can_dodge(x:bool) ->void :
	can_dodge = x

# Initialise les composants et applique la teinte bleue si joueur 2
func _ready() -> void:
	statemachine.init()
	spellLauncher.init()
	hit_received.connect(_on_hit_received)
	if player_id % 2 == 1:
		apply_blue_filter($Sprite)

# Joue le bruitage d'impact spécifique à l'attaque reçue
func _on_hit_received(attack: AttackData) -> void:
	if attack.hit_sound == null:
		return

	hurt_sound.stream = attack.hit_sound
	hurt_sound.play()

# Transmet les commandes d'action si le match et le sauvetage ne bloquent pas le joueur
func _input(event: InputEvent) -> void:
	if match_over or rescue_controller.rescue_active or rescue_controller.failed:
		return
	statemachine.process_input(event)
	spellLauncher.process_input(event)

# Met à jour la logique de frame de la machine à états et des sorts
func _process(delta: float) -> void:
	if match_over:
		return
	statemachine.process_frame(delta)
	if not rescue_controller.rescue_active and not rescue_controller.failed:
		spellLauncher.process_frame(delta)

# Traite la physique, les sorts et le déplacement du personnage
func _physics_process(delta: float) -> void:
	statemachine.process_physics(delta)
	if not rescue_controller.rescue_active and not rescue_controller.failed:
		spellLauncher.process_physics(delta)
	move_and_slide()

# Reçoit une attaque, augmente les dégâts accumulés et vérifie le seuil critique de sauvetage
func takeAttack(data: AttackData, attackerPos: Vector2,
		attackerOrientation: int) -> void:
	if match_over or rescue_controller.rescue_active or rescue_controller.failed:
		return
		
	hit_received.emit(data)
	
	ddhealth += data.damage
	$DDHealthDisplayer.update_ddhealth(ddhealth)
	ddhealth_changed.emit()

	# Si les dégâts atteignent le seuil critique, la séquence de sauvetage démarre
	if ddhealth >= dying_threshold:
		rescue_controller.begin_rescue()
		return

	statemachine.take_attack(data, attackerPos, attackerOrientation)

# Soigne le joueur en réduisant ses points de DDHealth
func heal(x: int) -> void:
	ddhealth = maxi(0, ddhealth - x)
	ddhealth_changed.emit()

# Applique un shader de remplacement de couleur (rouge vers bleu) sur le sprite
func apply_blue_filter(s: AnimatedSprite2D) -> void:
	var mat = ShaderMaterial.new()
	mat.shader = shader_code
	
	mat.set_shader_parameter("target_color", Color(1.0, 0.0, 0.0)) # Rouge d'origine à remplacer
	mat.set_shader_parameter("replace_color", Color(0.0, 0.4, 1.0)) # Teinte bleue de remplacement
	mat.set_shader_parameter("tolerance", 0.5) # Tolérance de détection des nuances
	
	s.material = mat
	
	
