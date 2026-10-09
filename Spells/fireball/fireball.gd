class_name Fireball
extends Node2D

@export var speed: float = 6.0          # pixels par frame physique (≈ 480 px/s à 60 Hz)
@export var lifetime_frames: int = 180  # disparaît seule après 3 s si elle ne touche rien

var attack: AttackData = preload("res://Spells/fireball.tres")
var caster: Player
var direction: int = 1
var frame_counter: int = 0

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: Hitbox = $Hitbox

func _ready() -> void:
	sprite.play()
	hitbox.area_entered.connect(_on_hitbox_area_entered)

# À appeler APRÈS add_child() : le Hitbox doit déjà être dans l'arbre, sous le joueur.
func setup(p_caster: Player, p_direction: int, spawn_position: Vector2) -> void:
	caster = p_caster
	direction = p_direction
	top_level = true            # reste en coordonnées monde, ne suit pas le joueur
	global_position = spawn_position
	sprite.flip_h = direction < 0
	hitbox.owner = caster       # la hurtbox du lanceur ignore alors cette attaque
	hitbox.player = caster      # getOwnerPosition()/getOwnerOrientation() ne plantent pas
	hitbox.activateAttack(attack)

func process_physics() -> void:
	global_position.x += direction * speed
	frame_counter += 1
	if frame_counter >= lifetime_frames:
		queue_free()
		

func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.owner == caster:
		return
	#queue_free()   # la boule de feu disparaît au premier impact
