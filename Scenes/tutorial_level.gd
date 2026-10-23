extends Node

@export var player1: Player
@export var sandbag: Sandbag
@export var tutorialManager : TutorialManager
var match_finished: bool = false
var winner_number: int = 0

var bus_index: int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Jukebox.play_music()
	Jukebox.set_bass_boost(0.0)
	
	# Signal pour passer au game over
	var controller: Node = player1.get_node("RescueController")
	controller.connect("rescue_failed", _on_rescue_failed)
	player1.connect("ddhealth_changed", update_bass_boost)
		

func update_bass_boost():
	var value: float = float(player1.ddhealth)/2 /70
	Jukebox.set_bass_boost(value)

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
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	tutorialManager.process_input(event)
	

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")

func rescue_background() ->void:
	pass
	


func _on_touches_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/controls.tscn")
