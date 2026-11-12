# Gestion de l'affichage des barres de dégâts (DDHealth) pour les deux joueurs dans l'interface.
extends Control

@export var player1: Player 
@export var player2: Player

@onready var p1_bar: ProgressBar = $P1Damage
@onready var p2_bar: ProgressBar = $P2Damage

# Initialise le seuil maximal des barres et connecte les signaux de changement de dégâts.
func _ready() -> void:
	p1_bar.max_value = player1.dying_threshold
	p2_bar.max_value = player2.dying_threshold

	player1.damage_changed.connect(_on_p1_damage_changed)
	player2.damage_changed.connect(_on_p2_damage_changed)

	_on_p1_damage_changed(player1.ddhealth)
	_on_p2_damage_changed(player2.ddhealth)

# Met à jour la barre de vie du joueur 1.
func _on_p1_damage_changed(value: int) -> void:
	p1_bar.value = value

# Met à jour la barre de vie du joueur 2.
func _on_p2_damage_changed(value: int) -> void:
	p2_bar.value = value
