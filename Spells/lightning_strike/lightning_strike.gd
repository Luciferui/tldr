class_name LightningStrike
extends Node2D

var attack = preload("res://Spells/lightning_strike/lightning_strike.tres")
var spell = preload("res://Spells/spell3.tres")

@onready var collision_shape: CollisionShape2D = $Hitbox/LightningStrike
@onready var sprite: AnimatedSprite2D = $LightningStrike
@onready var spell_audio: AudioStreamPlayer = $SpellAudio

var frame_counter : int = 0

func process_physics() -> void:
	if frame_counter == 0:
		sprite.modulate[3] = 0.2 #transparence de l'avertissement
	if frame_counter == 50 :
		$Hitbox.activateAttack(attack)
		sprite.modulate[3] = 1  #l'éclair est opaque lorsqu'il tape
	if frame_counter > 60 :
		_on_spell_animation_finished()
	frame_counter +=1

func _ready() -> void:
	spell_audio.stream = spell.spell_sound
	spell_audio.play()
	self.position = Vector2(0,0)
	sprite.play("lightning")
	$Hitbox.setCurrentAttack(attack)
	$Hitbox.flipActivationAttack(attack)

func setup(x_position: float, p_caster: Player) -> void:
	global_position = Vector2(x_position, 0)
	$Hitbox.owner = p_caster
	
func _on_spell_animation_finished() -> void:
	sprite.hide()

	if spell_audio.playing:
		await spell_audio.finished

	queue_free()
