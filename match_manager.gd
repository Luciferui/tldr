extends Node

@export var player1: Player
@export var player2: Player

var match_finished: bool = false
var winner_number: int = 0

func _ready() -> void:
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
		controller.rescue_active = false

		player.get_node("Ddr").set_physics_process(false)
		player.get_node("Hitbox").deactivateAttack()
