extends Control

@export var player1: Player 
@export var player2: Player

@onready var p1_bar: ProgressBar = $P1Damage
@onready var p2_bar: ProgressBar = $P2Damage
# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	p1_bar.max_value = player1.dying_threshold
	p2_bar.max_value = player2.dying_threshold

	player1.damage_changed.connect(_on_p1_damage_changed)
	player2.damage_changed.connect(_on_p2_damage_changed)

	_on_p1_damage_changed(player1.ddhealth)
	_on_p2_damage_changed(player2.ddhealth)


func _on_p1_damage_changed(value: int) -> void:
	p1_bar.value = value


func _on_p2_damage_changed(value: int) -> void:
	p2_bar.value = value
