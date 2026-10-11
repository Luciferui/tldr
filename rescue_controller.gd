extends Node

signal rescue_failed(loser: Player)

@export var ddr: RandomDDR
@export var time_limit: float = 5.0
@export var required_inputs: int

@onready var player: Player = get_parent() as Player
@onready var dying: PlayerDyingState = $"../StateMachine/Dying"
@onready var idle: PlayerState = $"../StateMachine/Idle"
@onready var fall: PlayerState = $"../StateMachine/Fall"

var rescue_active: bool = false
var failed: bool = false
var deadline_ms: int = 0

func _ready() -> void:
	pass

func begin_rescue() -> void:
	if rescue_active or failed:
		return
	rescue_active = true

	ddr.playerInputs = [] # réinit les inputs entrées
	
	deadline_ms = Time.get_ticks_msec() + int(time_limit * 1000)
	player.statemachine.override_state(dying)
	required_inputs = player.ddhealth

func _process(_delta: float) -> void:
	if not rescue_active:
		return
	var remaining := maxf(0.0, (deadline_ms - Time.get_ticks_msec()) / 1000.0)
	if remaining <= 0.0:
		_fail()

func ddr_input_changed() -> void:
	if not rescue_active:
		return
		
	if Time.get_ticks_msec() >= deadline_ms:
		_fail()
		return
	print(ddr.total_input, "   ", required_inputs)
	if ddr.total_input >= required_inputs:
		rescue_active = false
		player.ddhealth = floori(player.ddhealth / 2.0)
		#player.damage_changed.emit(player.ddhealth)
		
		player.statemachine.override_state(idle if player.is_on_floor() else fall)

func _fail() -> void:
	rescue_active = false
	failed = true
	rescue_failed.emit(player) # Pour que le level charge la scène suivante
