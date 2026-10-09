class_name SpellLauncher
extends Node2D

const LightningStrikeScene := preload("res://Spells/lightning_strike/lightning_strike.tscn")
const FireballScene := preload("res://Spells/fireball/Fireball.tscn")
const FIREBALL_SPAWN_OFFSET := Vector2(60, 0)  # devant le joueur, à ajuster à l'œil
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
				_cast_lightning()
			2:
				_cast_lightning()
			3:
				_cast_lightning()
			_:
				push_warning("Unknown spell detected in hold")
		player.set_hold(-1)
		
func process_frame(delta: float) -> void:
	pass

func _cast_lightning() -> void:
	if player.opponent == null:
		push_warning("opponent non assigné sur ce Player")
		return
	var strike: LightningStrike = LightningStrikeScene.instantiate()
	self.add_child(strike)
	strike.setup(player.opponent.global_position.x)

func _cast_fireball() -> void:
	var fireball: Fireball = FireballScene.instantiate()
	add_child(fireball)  # d'abord dans l'arbre, ensuite setup()
	fireball.setup(player, player.get_sprite_faces_left(), player.global_position + Vector2((-1 if player.get_sprite_faces_left() else 1) * FIREBALL_SPAWN_OFFSET.x, FIREBALL_SPAWN_OFFSET.y))

func process_physics(delta: float) -> void:
	for child in self.get_children():
		child.process_physics()
