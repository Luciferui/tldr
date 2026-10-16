class_name Meteorite
extends Node2D
## Une météorite : tombe tout droit, fait des dégâts pendant la chute,
## puis joue son explosion et disparaît quand elle touche le sol.

const FALL_ANIM := &"fall"            
const EXPLOSION_ANIM := &"explosion"

var attack: AttackData = preload("res://Spells/meteorites/meteorite.tres")

@export var fall_speed: float = 8.0   # pixels par frame physique (≈ 480 px/s à 60 Hz)
@export var kill_y: float = 400.0     # sécurité : si aucun sol n'est touché, on supprime la météorite

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var hitbox: Hitbox = $Hitbox
@onready var ground_detector: Area2D = $GroundDetector

var landed: bool = false


func _ready() -> void:
	ground_detector.body_entered.connect(_on_ground_body_entered)
	hitbox.activateAttack(attack)  # la météorite fait des dégâts pendant toute sa chute
	if _has_frames(FALL_ANIM):
		sprite.play(FALL_ANIM)


func setup(spawn_position: Vector2, p_caster: Player) -> void:
	global_position = spawn_position
	hitbox.owner = p_caster


func process_physics() -> void:
	if landed:
		return
	global_position.y += fall_speed
	if global_position.y > kill_y:
		queue_free()


func _on_ground_body_entered(body: Node2D) -> void:
	# Le sol et les plateformes sont des StaticBody2D ; les joueurs (CharacterBody2D) sont ignorés
	if body is StaticBody2D:
		_land()


func _land() -> void:
	if landed:
		return
	landed = true
	hitbox.deactivateAttack()  # pas de dégâts pendant l'explosion
	if _has_frames(EXPLOSION_ANIM):
		sprite.play(EXPLOSION_ANIM)
		sprite.animation_finished.connect(queue_free, CONNECT_ONE_SHOT)
	else:
		queue_free()


func _has_frames(anim: StringName) -> bool:
	return sprite.sprite_frames != null \
		and sprite.sprite_frames.has_animation(anim) \
		and sprite.sprite_frames.get_frame_count(anim) > 0
