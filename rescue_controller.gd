extends Node

signal rescue_progress_changed(count: int, remaining: float)
signal rescue_failed(loser: Player)

@export var ddr: Node
@export var time_limit: float = 5.0
@export var required_inputs: int = 35

@onready var player: Player = get_parent() as Player
@onready var dying: PlayerDyingState = $"../StateMachine/Dying"
@onready var idle: PlayerState = $"../StateMachine/Idle"
@onready var fall: PlayerState = $"../StateMachine/Fall"

var active: bool = false
var failed: bool = false
var start_total: int = 0
var progress: int = 0
var deadline_ms: int = 0

func _ready() -> void:
	ddr.connect("total_input_change", _on_total_input_changed)

func begin_rescue() -> void:
	if active or failed:
		return
	active = true
	progress = 0
	start_total = ddr.total_input
	deadline_ms = Time.get_ticks_msec() + int(time_limit * 1000)
	player.statemachine.override_state(dying)
	rescue_progress_changed.emit(0, time_limit)

func _process(_delta: float) -> void:
	if not active:
		return
	var remaining := maxf(
		0.0, (deadline_ms - Time.get_ticks_msec()) / 1000.0
	)
	rescue_progress_changed.emit(progress, remaining)
	if remaining <= 0.0:
		_fail()

func _on_total_input_changed(total: int) -> void:
	if not active:
		return
	if Time.get_ticks_msec() >= deadline_ms:
		_fail()
		return
	progress = total - start_total
	if progress >= required_inputs:
		active = false
		progress = required_inputs
		player.ddhealth = floori(player.ddhealth / 2.0)
		player.damage_changed.emit(player.ddhealth)
		rescue_progress_changed.emit(progress, 0.0)
		player.statemachine.override_state(
			idle if player.is_on_floor() else fall
		)

func _fail() -> void:
	if not active:
		return
	active = false
	failed = true
	rescue_failed.emit(player)
