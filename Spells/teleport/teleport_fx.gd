class_name Teleport
extends Node2D

@onready var particles: CPUParticles2D = $Particles
@onready var spell_audio: AudioStreamPlayer = $SpellAudio

var spell = preload("res://Spells/spell4.tres")

# À appeler APRÈS add_child()
func setup(pos: Vector2, tint: Color) -> void:
	spell_audio.stream = spell.spell_sound
	spell_audio.play()
	global_position = pos
	z_index = 10   # au-dessus des joueurs
	modulate = tint
	particles.emitting = true
	await get_tree().create_timer(particles.lifetime + 0.1).timeout
	queue_free()
