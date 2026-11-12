## Gestionnaire de lancement des sorts pour un joueur.
## Instancie et configure les scènes de sorts (boules de feu, glace, éclair, téléportation, météorites) stockées en réserve.
class_name SpellLauncher
extends Node2D

const LightningStrikeScene := preload("res://Spells/lightning_strike/lightning_strike.tscn")
const FireballScene := preload("res://Spells/fireball/Fireball.tscn")
const FIREBALL_SPAWN_OFFSET := Vector2(20, 0)  # Décalage d'apparition devant le lanceur
const TeleportFxScene := preload("res://Spells/teleport/teleport_fx.tscn")
const TELEPORT_OFFSET := 20.0   # Distance d'arrivée par rapport à l'adversaire
const MeteoritesScene := preload("res://Spells/meteorites/meteorites.tscn")
const IceballScene := preload("res://Spells/iceball/Iceball.tscn")
const ICEBALL_SPAWN_OFFSET := Vector2(20, 0)  # Décalage d'apparition devant le lanceur

var player : Player

# Récupère le joueur propriétaire de ce lanceur de sorts
func _ready() ->void:
	player = owner as Player
	
func init() ->void:
	pass

# Détecte l'appui sur la touche de sort pour déclencher le sort stocké en réserve
func process_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed(player.spell_action):
		var spell_id = player.get_hold()
		if spell_id == -1:
			return # Aucun sort préparé en réserve
			
		# Exécution du sort correspondant à l'identifiant stocké
		match spell_id:
			1: # Boule de feu
				_cast_fireball()
			2: # Boule de glace
				_cast_iceball()
			3: # Éclair
				_cast_lightning()
			4: # Téléportation
				_cast_teleport()
			5: # Météorites
				_cast_meteorites()
			_:
				push_warning("Unknown spell detected in hold")
				
		# Masque les indicateurs visuels de sort en réserve dans le DDR
		player.get_node("Ddr").display_hold_spell(0, false)
		player.get_node("Ddr").display_hold_spell(1, false)
		player.get_node("Ddr").display_hold_spell(2, false)
		
		player.set_hold(-1)
		
func process_frame(_delta: float) -> void:
	pass

# Invoque un éclair vertical au-dessus de l'adversaire
func _cast_lightning() -> void:
	if player.opponent == null:
		push_warning("opponent non assigné sur ce Player")
		return
	var strike: LightningStrike = LightningStrikeScene.instantiate()
	self.add_child(strike)
	strike.setup(player.opponent.global_position.x, player)

# Invoque et lance un projectile de feu
func _cast_fireball() -> void:
	var fireball: Fireball = FireballScene.instantiate()
	add_child(fireball)
	fireball.setup(player, player.get_sprite_faces_left(), player.global_position + Vector2((-1 if player.get_sprite_faces_left() else 1) * FIREBALL_SPAWN_OFFSET.x, 0))

# Invoque et lance un projectile de glace
func _cast_iceball() -> void:
	var iceball: Iceball = IceballScene.instantiate()
	add_child(iceball)
	iceball.setup(player, player.get_sprite_faces_left(), player.global_position + Vector2((-1 if player.get_sprite_faces_left() else 1) * ICEBALL_SPAWN_OFFSET.x, 0))

# Téléporte le joueur à proximité de son adversaire avec effets visuels
func _cast_teleport() -> void:
	if player.opponent == null:
		push_warning("opponent non assigné sur ce Player")
		return
	var facing: float = -1.0 if player.get_sprite_faces_left() else 1.0
	var target: Vector2 = player.opponent.global_position
	var destination := Vector2(target.x - facing * TELEPORT_OFFSET, target.y)

	_spawn_teleport_fx(player.global_position, Color(0.6, 0.4, 1.0))  # Effet au départ
	player.global_position = destination
	player.velocity = Vector2.ZERO
	_spawn_teleport_fx(destination, Color(0.4, 0.9, 1.0))             # Effet à l'arrivée

# Instancie l'effet visuel et sonore de téléportation
func _spawn_teleport_fx(pos: Vector2, tint: Color) -> void:
	var fx = TeleportFxScene.instantiate()
	get_tree().current_scene.add_child(fx)
	fx.setup(pos, tint)

# Invoque une pluie de météorites ciblant la colonne de l'adversaire
func _cast_meteorites() -> void:
	if player.opponent == null:
		push_warning("opponent non assigné sur ce Player")
		return
	var meteorites: Meteorites = MeteoritesScene.instantiate()
	add_child(meteorites)
	meteorites.setup(player.opponent.global_position.x, player)

# Transmet la frame physique à chacun des sorts actifs enfants
func process_physics(_delta: float) -> void:
	for child in self.get_children():
		child.process_physics()
