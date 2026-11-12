# Script principal de niveau de match : gère l'ambiance sonore dynamique, le menu pause et la fin de partie.
extends Node

@export var player1: Player
@export var player2: Player
var match_finished: bool = false
var winner_number: int = 0

var bus_index: int

# Gère l'affichage/masquage du menu des contrôles avec la touche Échap
func _process(_delta: float):
	if Input.is_action_just_pressed("Esc"):
		flip_inputs_menu()

# Démarre la musique, réinitialise les basses et connecte les signaux de sauvetage et de dégâts
func _ready() -> void:
	Jukebox.play_music()
	Jukebox.set_bass_boost(0.0)
	
	for player in [player1, player2]:
		var controller: Node = player.get_node("RescueController")
		controller.connect("rescue_failed", _on_rescue_failed)
		player.connect("ddhealth_changed", update_bass_boost)

# Amplifie les basses fréquences de la musique selon la somme des dégâts accumulés par les deux joueurs
func update_bass_boost():
	var value: float = float((player1.ddhealth+player2.ddhealth))/2 /40
	Jukebox.set_bass_boost(value)

# Déclenché lors de l'échec d'un sauvetage : enregistre le vainqueur et charge l'écran de Game Over
func _on_rescue_failed(loser: Player) -> void:
	if match_finished:
		return

	match_finished = true
	DataManager.player_won = 2 if loser == player1 else 1

	for player in [player1, player2]:
		player.match_over = true
		player.velocity = Vector2.ZERO

		var controller: Node = player.get_node("RescueController")
		controller.rescue_active = false

		player.get_node("Ddr").set_physics_process(false)
		player.get_node("Hitbox").deactivateAttack()
	
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

# Bascule l'affichage du menu des contrôles et des combattants
func flip_inputs_menu():
	$Controls.visible = !$Controls.visible
	$Player.visible = !$Player.visible
	$Player2.visible = !$Player2.visible

func rescue_background() ->void:
	pass

func _on_return_button_pressed() -> void:
	pass
