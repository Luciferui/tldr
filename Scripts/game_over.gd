# Écran de fin de partie (Game Over) : affiche le vainqueur, positionne les personnages et permet le retour aux menus.
extends Node

@onready var sprite: AnimatedSprite2D = $"Gameover Sprite"
@onready var player1:= $Player
@onready var player2:= $Player2

# Lance l'animation de fin, configure les positions selon le vainqueur et programme la transition automatique
func _ready() -> void:
	sprite.play(&"gameover")
	if DataManager.player_won%2 == 1:
		$RichTextLabel.text = "Player 1 has won"
		player2.position = Vector2(0, 42)
		player1.position = Vector2(-120, 36)
		
		player2.set_collision_mask_value(2, true)
		player2.set_collision_layer_value(2, true)
		player2.set_collision_mask_value(1, false)
		player2.set_collision_layer_value(1, false)
		
		player1.set_collision_mask_value(1, true)
		player1.set_collision_layer_value(1, true)
		player1.set_collision_mask_value(2, false)
		player1.set_collision_layer_value(2, false)
	else:
		$RichTextLabel.text = "Player 2 has won"
		player1.position = Vector2(0, 36)
		player2.position = Vector2(-120, 36)
		
		player1.set_collision_mask_value(2, true)
		player1.set_collision_layer_value(2, true)
		player1.set_collision_mask_value(1, false)
		player1.set_collision_layer_value(1, false)
		
		player2.set_collision_mask_value(1, true)
		player2.set_collision_layer_value(1, true)
		player2.set_collision_mask_value(2, false)
		player2.set_collision_layer_value(2, false)
		
	# Suppression des éléments d'interface de combat devenus inutiles
	$"Player/DDHealthDisplayer".visible = false
	$"Player/Ddr".queue_free()
	$"Player2/DDHealthDisplayer".visible = false
	$"Player2/Ddr".queue_free()
	
	# Transition automatique vers le menu des sorts après 10 secondes
	await get_tree().create_timer(10.0).timeout
	get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")

# Permet de passer l'écran et de revenir au menu de sélection des sorts via la touche d'attaque lourde
func _back_to_menus() -> void:
	await get_tree().create_timer(5.0).timeout
	if Input.is_action_just_pressed("p1_heavy"):
		get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")

# Écoute les entrées à chaque frame pour un retour anticipé aux menus
func _process(_delta: float) -> void:
	_back_to_menus()
