class_name Meteorites
extends Node2D
## Sort "Météorites" : un avertissement, puis 3 météorites qui tombent à tour de rôle
## sur 3 colonnes distinctes autour de la position x de la cible.

const MeteoriteScene := preload("res://Spells/meteorites/meteorite.tscn")

@export var column_spacing: float = 60.0    # écart en x entre deux colonnes
@export var warning_frames: int = 50        # durée de l'avertissement (comme lightning_strike)
@export var spawn_interval_frames: int = 6  # 6 frames = 0,1 s à 60 Hz
@export var spawn_y: float = -200.0         # au-dessus de l'écran (caméra zoom 3 : le haut visible est y = -180)

@onready var warnings: Array[Sprite2D] = [$Warning0, $Warning1, $Warning2]

var caster: Player
var frame_counter: int = 0
var spawned: int = 0
var column_order: Array[int] = [0, 1, 2]  # ordre de tombée des colonnes (mélangé dans _ready)


func _ready() -> void:
	column_order.shuffle()
	for i in warnings.size():
		warnings[i].position = Vector2((i - 1) * column_spacing, 0)
		warnings[i].modulate.a = 0.2  # transparence de l'avertissement


func setup(x_position: float, p_caster: Player) -> void:
	caster = p_caster
	global_position = Vector2(x_position, 0)


func process_physics() -> void:
	# Lancement échelonné, une fois l'avertissement terminé
	if spawned < column_order.size() and frame_counter >= warning_frames + spawned * spawn_interval_frames:
		_spawn_meteorite(column_order[spawned])
		spawned += 1

	# Les météorites sont pilotées d'ici (comme le SpellLauncher le fait avec ses enfants)
	var alive := 0
	for child in get_children():
		var meteorite := child as Meteorite
		if meteorite != null and not meteorite.is_queued_for_deletion():
			meteorite.process_physics()
			alive += 1

	if spawned == column_order.size() and alive == 0:
		queue_free()
	frame_counter += 1


func _spawn_meteorite(column: int) -> void:
	var meteorite: Meteorite = MeteoriteScene.instantiate()
	add_child(meteorite)  # d'abord dans l'arbre, ensuite setup()
	meteorite.setup(Vector2(global_position.x + (column - 1) * column_spacing, spawn_y), caster)
	warnings[column].visible = false  # l'avertissement d'une colonne disparaît quand sa météorite part
