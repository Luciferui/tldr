# Menu de sélection musicale : permet de choisir le morceau joué par le Jukebox.
extends Node

# Initialise l'affichage du nom de la musique courante
func _ready() -> void:
	update_music_name()

func _process(delta: float) -> void:
	pass

# Met à jour le label indiquant le morceau actuellement actif dans le Jukebox
func update_music_name():
	$CurrentMusic/Label.text = Jukebox.chosen_song

# Retourne à l'écran de sélection des sorts
func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")

# Change le morceau sélectionné, lance la lecture et met à jour l'affichage
func _on_change_music_button_pressed(music_name: String):
	Jukebox.chosen_song = music_name
	Jukebox.play_music()
	update_music_name()
