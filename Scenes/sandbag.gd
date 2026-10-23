class_name Sandbag
extends CharacterBody2D

@onready var statemachine: StateMachine = $StateMachine
@onready var sprite: AnimatedSprite2D = $Sprite
@export var player_id: int = 1

signal ddhealth_changed # Pour booster les bass

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

func _unhandled_input(event: InputEvent) -> void:
	if match_over:
		return
	statemachine.process_input(event)

func _process(delta: float) -> void:
	if match_over:
		return
	statemachine.process_frame(delta)

func _physics_process(delta: float) -> void:
	statemachine.process_physics(delta)
	move_and_slide()

func takeAttack(data: AttackData, attackerPos: Vector2,
		attackerOrientation: int) -> void:
	if match_over:
		return

	ddhealth += data.damage
	$DDHealthDisplayer.update_ddhealth(ddhealth)
	ddhealth_changed.emit()
	statemachine.take_attack(data, attackerPos, attackerOrientation)
