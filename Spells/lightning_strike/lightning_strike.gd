## Sort Éclair : frappe foudroyante verticale sur la position x ciblée avec avertissement préalable.
class_name LightningStrike
extends Node2D

var attack = preload("res://Spells/lightning_strike/lightning_strike.tres")
var spell = preload("res://Spells/spell3.tres")

@onready var collision_shape: CollisionShape2D = $Hitbox/LightningStrike
@onready var sprite: AnimatedSprite2D = $LightningStrike
@onready var spell_audio: AudioStreamPlayer = $SpellAudio

var frame_counter : int = 0

# Gère le cycle de l'attaque : avertissement transparent (frames 0-50), impact opaque (frame 50), fin (frame 60)
func process_physics() -> void:
	if frame_counter == 0:
		sprite.modulate[3] = 0.2 # Transparence de l'avertissement visuel
	if frame_counter == 50 :
		$Hitbox.activateAttack(attack)
		sprite.modulate[3] = 1  # L'éclair devient totalement opaque au moment de l'impact
	if frame_counter > 60 :
		_on_spell_animation_finished()
	frame_counter +=1

# Initialise le son, l'animation et l'attaque associée
func _ready() -> void:
	spell_audio.stream = spell.spell_sound
	spell_audio.play()
	self.position = Vector2(0,0)
	sprite.play("lightning")
	$Hitbox.setCurrentAttack(attack)
	$Hitbox.flipActivationAttack(attack)

# Positionne l'éclair horizontalement sur la cible et assigne le propriétaire de la hitbox
func setup(x_position: float, p_caster: Player) -> void:
	global_position = Vector2(x_position, 0)
	$Hitbox.owner = p_caster

# Masque le sprite et attend la fin de l'audio avant de supprimer le nœud
func _on_spell_animation_finished() -> void:
	sprite.hide()

	if spell_audio.playing:
		await spell_audio.finished

	queue_free()
