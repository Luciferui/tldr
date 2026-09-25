class_name SpellLauncher
extends Node2D

var player : Player

func _ready() ->void:
	player = owner as Player
	
func init() ->void:
	pass

func process_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed(player.spell_action):
		var spell_n = player.get_hold()
		if spell_n == -1:
			#il n'y a pas de sort préparé
			return
		match spell_n:
			1:
				player.heal(10)
			2:
				player.heal(10)
			3:
				player.heal(10)
			_:
				push_warning("Unknown spell detected in hold")
		player.set_hold(-1)
		
func process_frame(delta: float) -> void:
	pass

func process_physics(delta: float) -> void:
	pass
