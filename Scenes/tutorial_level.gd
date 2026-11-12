# Script principal de la scène de tutoriel : initialise la musique, gère le menu pause et écoute l'échec de sauvetage.
extends Node

@onready var controls_menu : CanvasLayer = $Controls

@export var player1: Player
@export var sandbag: Sandbag
@export var tutorialManager : TutorialManager
var match_finished: bool = false
var winner_number: int = 0

var bus_index: int

# Lance la musique, initialise les effets audio et connecte les signaux de sauvetage et de dégâts
func _ready() -> void:
	Jukebox.play_music()
	Jukebox.set_bass_boost(0.0)
	
	var controller: Node = player1.get_node("RescueController")
	controller.connect("rescue_failed", _on_rescue_failed)
	player1.connect("ddhealth_changed", update_bass_boost)

# Gère l'ouverture du menu des contrôles et transmet les entrées au gestionnaire de tutoriel
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("Esc"):
		flip_inputs_menu()
	tutorialManager.process_input(event)

# Met à jour le renforcement des basses en fonction des dégâts reçus par le joueur
func update_bass_boost():
	var value: float = float(player1.ddhealth)/2 /70
	Jukebox.set_bass_boost(value)

# Déclenché lorsque le joueur échoue lors de la phase de sauvetage (passage à l'écran de fin)
func _on_rescue_failed(loser: Player) -> void:
	if match_finished:
		return

	match_finished = true
	winner_number = 2 if loser == player1 else 1

	player1.match_over = true
	player1.velocity = Vector2.ZERO

	var controller: Node = player1.get_node("RescueController")
	controller.rescue_active = false

	player1.get_node("Ddr").set_physics_process(false)
	player1.get_node("Hitbox").deactivateAttack()

	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# Retourne à la scène du menu principal
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func rescue_background() ->void:
	pass

# Affiche ou masque le menu des contrôles en superposé
func flip_inputs_menu():
	controls_menu.visible = !controls_menu.visible
	$Player.visible = !$Player.visible
	$Sandbag.visible = !$Sandbag.visible
