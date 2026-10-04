extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	update_music_name()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func update_music_name():
	$CurrentMusic/Label.text = Jukebox.chosen_song

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")

func _on_change_music_button_pressed(music_name: String):
	Jukebox.chosen_song = music_name
	Jukebox.play_music()
	update_music_name()
