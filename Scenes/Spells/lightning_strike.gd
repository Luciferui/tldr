class_name LightningStrike
extends Node2D

var attack = preload("res://Attacks/lightning_strike.tres")
@onready var collision_shape: CollisionShape2D = $Hitbox/LightningStrike
@onready var sprite: AnimatedSprite2D = $LightningStrike

var frame_counter : int = 0

func process_physics() -> void:
	if frame_counter == 10 :
		$Hitbox.activateAttack(attack)
	if frame_counter > 50 :
		queue_free()
	frame_counter +=1

func _ready() -> void:
	sprite.play("lightning")

func setup(x_position: float) -> void:
	global_position = Vector2(x_position, 0)
