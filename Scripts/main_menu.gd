extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	var bus_index = AudioServer.get_bus_index("Music")
	var eq_effect = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectEQ
	eq_effect.set_band_gain_db(0, 0.) # 32 Hz
	eq_effect.set_band_gain_db(1, 0.) # 100 Hz
	Jukebox.play_music()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
