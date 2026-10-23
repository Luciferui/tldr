extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Jukebox.play_music()
	Jukebox.set_bass_boost(0.)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_tutorial_button_pressed() -> void:
	const SPELL_1: SpellData = preload("res://Spells/spell1.tres")
	const SPELL_3: SpellData = preload("res://Spells/spell3.tres")
	const SPELL_5: SpellData = preload("res://Spells/spell5.tres")
	DataManager.distribute_spells([SPELL_1,SPELL_3,SPELL_5],[SPELL_1,SPELL_3,SPELL_5])
	get_tree().change_scene_to_file("res://Scenes/tutorial_level.tscn")
