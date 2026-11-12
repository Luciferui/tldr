# Contrôleur du menu principal : lancement de partie, accès au tutoriel et affichage des contrôles.
extends Control

# Affiche le curseur de souris et lance la musique d'ambiance du menu
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Jukebox.play_music()
	Jukebox.set_bass_boost(0.)

# Écoute la touche Échap pour ouvrir/fermer le panneau des contrôles
func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("Esc"):
		flip_inputs_menu()

# Démarre la sélection des sorts et capture le curseur
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

# Bascule la visibilité de l'aide des contrôles
func flip_inputs_menu():
	$Controls.visible = !$Controls.visible

# Pré-équipe les sorts par défaut et charge la scène du tutoriel
func _on_tutorial_button_pressed() -> void:
	const SPELL_1: SpellData = preload("res://Spells/spell1.tres")
	const SPELL_3: SpellData = preload("res://Spells/spell3.tres")
	const SPELL_5: SpellData = preload("res://Spells/spell5.tres")
	DataManager.distribute_spells([SPELL_1,SPELL_3,SPELL_5],[SPELL_1,SPELL_3,SPELL_5])
	get_tree().change_scene_to_file("res://Scenes/tutorial_level.tscn")
