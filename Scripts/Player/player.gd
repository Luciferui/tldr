class_name Player
extends CharacterBody2D
##Joueur controllable [br]

@onready var statemachine: StateMachine = $StateMachine
@onready var spellLauncher : SpellLauncher = $SpellLauncher
@onready var sprite: AnimatedSprite2D = $Sprite

@export var player_id: int = 0
@export var left_action: StringName = &"p1_left"
@export var right_action: StringName = &"p1_right"
@export var jump_action: StringName = &"p1_jump"
@export var heavy_attack_action: StringName = &"p1_heavy"
@export var light_attack_action: StringName = &"p1_light"
@export var spell_action: StringName = &"p1_spell1"

signal damage_changed(total: int)

@export var dying_threshold: int = 30
@export var rescue: Node


@export var sprite_faces_left: bool = false
var ddhealth : int = 0

var holdSpell : int = -1

var match_over : bool = false
func get_hold(): 
	return holdSpell
func set_hold(hold: int): 
	holdSpell = hold

func _ready() -> void:
	statemachine.init()
	spellLauncher.init()

func _unhandled_input(event: InputEvent) -> void:
	if match_over or rescue.active or rescue.failed:
		return
	statemachine.process_input(event)
	spellLauncher.process_input(event)

func _process(delta: float) -> void:
	statemachine.process_frame(delta)
	spellLauncher.process_frame(delta)

func _physics_process(delta: float) -> void:
	if match_over:
		if statemachine.current_state is PlayerDeathState:
			statemachine.process_physics(delta)
			move_and_slide()
		return

	statemachine.process_physics(delta)
	if not rescue.active and not rescue.failed:
		spellLauncher.process_physics(delta)
	move_and_slide()

func takeAttack(data:AttackData) -> void:
	##Le joueur s'est prit l'attaque data.
	if match_over or rescue.active or rescue.failed:
		return

	ddhealth += data.damage
	damage_changed.emit(ddhealth)

	if ddhealth >= dying_threshold:
		rescue.begin_rescue()
	else:
		statemachine.take_stun(data.hitstun)
func heal(x : int) ->void:
	print("heal",x)
	ddhealth = max(0, ddhealth - x)


	
