## Mannequin d'entraînement (Sandbag) utilisé pour le tutoriel et le mode entraînement.
## Reçoit les coups, incrémente les dégâts reçus et réagit via sa propre machine à états.
class_name Sandbag
extends CharacterBody2D

@onready var statemachine: StateMachine = $StateMachine
@onready var sprite: AnimatedSprite2D = $Sprite
@export var player_id: int = 1

signal ddhealth_changed # Signal émis lors d'une variation de dégâts pour le boost des basses

# Retourne vrai si le sprite regarde vers la gauche
func get_sprite_faces_left() -> bool:
	return sprite.flip_h

var ddhealth : int = 0

var holdSpell : int = -1

var match_over: bool = false

# Accesseur pour le sort actuellement stocké
func get_hold(): 
	return holdSpell
func set_hold(hold: int): 
	holdSpell = hold
	
var can_dodge = true
func get_can_dodge() -> bool:
	return can_dodge
func set_can_dodge(x:bool) ->void :
	can_dodge = x

# Initialise la machine à états du mannequin
func _ready() -> void:
	statemachine.init()

# Transmet les entrées utilisateur non capturées à la machine à états
func _unhandled_input(event: InputEvent) -> void:
	if match_over:
		return
	statemachine.process_input(event)

# Met à jour la frame de la machine à états
func _process(delta: float) -> void:
	if match_over:
		return
	statemachine.process_frame(delta)

# Traite la physique de la machine à états et déplace le mannequin
func _physics_process(delta: float) -> void:
	statemachine.process_physics(delta)
	move_and_slide()

# Reçoit une attaque, augmente les dégâts accumulés et transmet le coup à la machine à états
func takeAttack(data: AttackData, attackerPos: Vector2,
		attackerOrientation: int) -> void:
	if match_over:
		return

	ddhealth += data.damage
	$DDHealthDisplayer.update_ddhealth(ddhealth)
	ddhealth_changed.emit()
	statemachine.take_attack(data, attackerPos, attackerOrientation)
