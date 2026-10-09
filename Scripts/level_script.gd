extends Node

@export var player1: Player
@export var player2: Player
var match_finished: bool = false
var winner_number: int = 0

var bus_index: int
var eq_effect: AudioEffectEQ
var bass_boost_intensity: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bus_index = AudioServer.get_bus_index("Music")
	eq_effect = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectEQ
	_maj_bass_boost()
	Jukebox.play_music()
	
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

	get_tree().change_scene_to_file("res://Scenes/game_over.tscn")


func _maj_bass_boost(value:int = 0.): #le signal donne la ddhealth dont on ne s'occupe pas
	if not eq_effect:
		return
	bass_boost_intensity = (player1.ddhealth+player2.ddhealth)/2/100.0
	# Sur un AudioEffectEQ6 :
	# Bande 0 = ~32 Hz, Bande 1 = ~100 Hz (les vraies basses)
	# Le gain s'exprime en décibels (dB), généralement entre -60 dB et +24 dB.
	
	var min_db = -2.0    # Niveau normal
	var max_db = 18.0   # Boost maximal (+18 dB)
	
	var boost_db_32 = lerp(min_db, max_db, bass_boost_intensity)
	var boost_db_100 = lerp(min_db, max_db/1.3, bass_boost_intensity)
	
	# Augmente le gain des basses sous 32Hz et 100Hz
	eq_effect.set_band_gain_db(0, boost_db_32) # 32 Hz
	eq_effect.set_band_gain_db(1, boost_db_100) # 100 Hz
	
func rescue_background() ->void:
	pass
	
