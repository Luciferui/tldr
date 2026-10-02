extends Control

@export var menu_music: AudioStream

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	Jukebox.play_music(menu_music)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass



func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
