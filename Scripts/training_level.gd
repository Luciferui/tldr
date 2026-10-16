extends Node

@export var player1: Player
@export var player2: CharacterBody2D
var match_finished: bool = false
var winner_number: int = 0

var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Jukebox.play_music()
	Jukebox.set_bass_boost(0.0)

func update_bass_boost():
	var value: float = float(player1.ddhealth)/2 /70
	Jukebox.set_bass_boost(value)

func _on_rescue_failed(_loser: Player) -> void:
	if match_finished:
		return

	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func rescue_background() ->void:
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
