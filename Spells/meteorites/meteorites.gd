## Sort Météorites : affiche un avertissement sur 3 colonnes puis fait s'abattre
## successivement 3 météorites dans un ordre aléatoire autour de la cible.
class_name Meteorites
extends Node2D

const MeteoriteScene := preload("res://Spells/meteorites/meteorite.tscn")

@export var column_spacing: float = 60.0    # Écart horizontal entre deux colonnes (pixels)
@export var warning_frames: int = 50        # Durée de l'avertissement visuel préalable
@export var spawn_interval_frames: int = 6  # Intervalle entre l'apparition de chaque météorite
@export var spawn_y: float = -200.0         # Hauteur d'apparition au-dessus du champ de vision

@onready var warnings: Array[Sprite2D] = [$Warning0, $Warning1, $Warning2]

var caster: Player
var frame_counter: int = 0
var spawned: int = 0
var column_order: Array[int] = [0, 1, 2]  # Ordre d'apparition des colonnes (mélangé aléatoirement)

# Positionne les 3 indicateurs de colonnes et applique la transparence d'avertissement
func _ready() -> void:
	column_order.shuffle()
	for i in warnings.size():
		warnings[i].position = Vector2((i - 1) * column_spacing, 0)
		warnings[i].modulate.a = 0.2

# Configure la position du sort sur l'axe X de la cible et assigne le lanceur
func setup(x_position: float, p_caster: Player) -> void:
	caster = p_caster
	global_position = Vector2(x_position, 0)

# Gère l'apparition échelonnée des météorites et met à jour leur physique
func process_physics() -> void:
	# Apparition échelonnée après la fin du temps d'avertissement
	if spawned < column_order.size() and frame_counter >= warning_frames + spawned * spawn_interval_frames:
		_spawn_meteorite(column_order[spawned])
		spawned += 1

	# Mise à jour de la physique des météorites encore en vol
	var alive := 0
	for child in get_children():
		var meteorite := child as Meteorite
		if meteorite != null and not meteorite.is_queued_for_deletion():
			meteorite.process_physics()
			alive += 1

	# Suppression du contrôleur lorsque toutes les météorites ont terminé leur cycle
	if spawned == column_order.size() and alive == 0:
		queue_free()
	frame_counter += 1

# Instancie et initialise une météorite sur la colonne désignée
func _spawn_meteorite(column: int) -> void:
	var meteorite: Meteorite = MeteoriteScene.instantiate()
	add_child(meteorite)
	meteorite.setup(Vector2(global_position.x + (column - 1) * column_spacing, spawn_y), caster)
	warnings[column].visible = false  # Masque l'indicateur d'avertissement de la colonne active
