
class_name Fireball
extends Node2D

@export var speed: float = 6.0
@export var warning_speed: float = 0.
@export var warning_duration_frames: int = 30
@export var lifetime_frames: int = 180

var attack: AttackData = preload("res://Spells/fireball/fireball.tres")
var caster: Player
var sprite_faces_left: bool
var frame_counter: int = 0
var initial_pos: Vector2
var is_warning: bool = true
var direction: int = 1

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: Hitbox = $Hitbox

func _ready() -> void:
	$Hitbox/FireballShape.set_deferred("disabled", true)
	sprite.play("warning")
	hitbox.area_entered.connect(_on_hitbox_area_entered)


# À appeler APRÈS add_child() : le Hitbox doit déjà être dans l'arbre, sous le joueur.
func setup(p_caster: Player, p_faces_left: bool, spawn_position: Vector2) -> void:
	caster = p_caster
	sprite_faces_left = p_faces_left
	top_level = true
	initial_pos = spawn_position
	global_position = initial_pos
	sprite.flip_h = sprite_faces_left
	hitbox.owner = caster    # la hurtbox du lanceur ignore maintenant cette attaque

func process_physics() -> void:
	if is_warning:
		frame_counter += 1

		if frame_counter >= warning_duration_frames:
			is_warning = false
			frame_counter = 0
			global_position = initial_pos
			sprite.play("fireball")
			hitbox.activateAttack(attack)

		return

	# Comportement normal de la boule de feu.
	global_position.x += speed * (-1 if sprite_faces_left else 1)
	frame_counter += 1

	if frame_counter >= lifetime_frames:
		queue_free()

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.owner == caster:
		return
	# queue_free() # la boule disparaît au premier impact

func get_sprite_faces_left() -> bool:
	return sprite_faces_left
