class_name LightningStrike
extends Node2D

var attack = preload("res://Spells/lightning_strike/lightning_strike.tres")
@onready var collision_shape: CollisionShape2D = $Hitbox/LightningStrike
@onready var sprite: AnimatedSprite2D = $LightningStrike

var frame_counter : int = 0

func process_physics() -> void:
	if frame_counter == 0:
		sprite.modulate[3] = 0.2 #transparence de l'avertissement
	if frame_counter == 50 :
		$Hitbox.activateAttack(attack)
		sprite.modulate[3] = 1  #l'éclair est opaque lorsqu'il tape
	if frame_counter > 60 :
		queue_free()
	frame_counter +=1

func _ready() -> void:
	self.position = Vector2(0,0)
	sprite.play("lightning")
	$Hitbox.setCurrentAttack(attack)
	$Hitbox.flipActivationAttack(attack)

func setup(x_position: float, p_caster: Player) -> void:
	global_position = Vector2(x_position, 0)
	$Hitbox.owner = p_caster
