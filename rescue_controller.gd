extends Node

signal rescue_failed(loser: Player)

@export var time_limit: float = 5.0

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

func begin_rescue() -> void:
	if player.ddhealth == 0:
		return
	if rescue_active or failed:
		return
	rescue_active = true

	ddr.playerInputs = [] # réinit les inputs entrées
	
	deadline_ms = Time.get_ticks_msec() + int(time_limit * 1000)
	player.statemachine.override_state(dying)
	required_inputs = player.ddhealth
	
	player.apply_dark_filter()
	
	flip_ddr_spell_visible()
	
	DDCounter.text = str(required_inputs)

func _process(_delta: float) -> void:
	if not rescue_active:
		return
	var remaining := maxf(0.0, (deadline_ms - Time.get_ticks_msec()) / 1000.0)
	if remaining <= 0.0:
		_fail()

func flip_ddr_spell_visible():
	ddr.get_node("SpellReady").visible = !ddr.get_node("SpellReady").visible
	ddr.get_node("SpellHold").visible = !ddr.get_node("SpellHold").visible
	ddr.get_node("DeathItems").visible = !ddr.get_node("DeathItems").visible
	ddr.get_node("Counter").visible = !ddr.get_node("Counter").visible
	ddr.get_node("FlameSprite").visible = !ddr.get_node("FlameSprite").visible

	
	

func ddr_input_changed() -> void:
	if not rescue_active:
		return
		
	if Time.get_ticks_msec() >= deadline_ms:
		_fail()
		return
	
	input_counter += 1
		
	DDCounter.text = str(required_inputs-input_counter)
	if input_counter >= required_inputs:
		rescue_active = false
		player.ddhealth = floori(player.ddhealth / 2.0)
		input_counter = 0
		
		ddr.playerInputs = []
		ddr.total_input = 0
		ddr.refresh_display()
		player.get_node("DDHealthDisplayer").update_ddhealth(player.ddhealth)
		
		flip_ddr_spell_visible()
		if player.player_id%2 == 0:
			player.sprite.material = null
		else:
			player.apply_blue_filter(player.get_node("Sprite"))
		
		player.statemachine.override_state(idle if player.is_on_floor() else fall)

func _fail() -> void:
	rescue_active = false
	failed = true
	rescue_failed.emit(player) # Pour que le level charge la scène suivante
