extends Node

@export var level_music : AudioStream
@export var player1: Player
@export var player2: Player
var match_finished: bool = false
var winner_number: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Jukebox.play_music(level_music)
	for player in [player1, player2]:
		var controller: Node = player.get_node("RescueController")
		controller.connect("rescue_failed", _on_rescue_failed)

func _on_rescue_failed(loser: Player) -> void:
	if match_finished:
		return

	match_finished = true
	winner_number = 2 if loser == player1 else 1

	for player in [player1, player2]:
		player.match_over = true
		player.velocity = Vector2.ZERO

		var controller: Node = player.get_node("RescueController")
		controller.active = false

		player.get_node("Ddr").set_physics_process(false)
		player.get_node("Hitbox").deactivateAttack()

	var death := loser.get_node(
		"StateMachine/Death"
	) as PlayerDeathState

	loser.statemachine.override_state(death)
	
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

	

	
