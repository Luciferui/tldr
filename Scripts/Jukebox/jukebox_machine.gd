# Gestionnaire audio global (Jukebox / Singleton) : contrôle la musique d'ambiance,
# les transitions de morceaux, le volume et le renforcement dynamique des basses (bass boost).
extends Node

# Référence vers le lecteur audio persistant entre les changements de scène
var music_player: AudioStreamPlayer
var chosen_song: String = "Volcanic Bomb"
var bus_index: int
var eq_effect: AudioEffectEQ

# Configure le lecteur audio sur le bus 'Music' et récupère l'effet d'égalisation (EQ)
func _ready() -> void:
	music_player = AudioStreamPlayer.new()
	music_player.bus = "Music" 
	
	bus_index = AudioServer.get_bus_index("Music")
	eq_effect = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectEQ
	
	add_child(music_player)

# Démarre la lecture du morceau sélectionné (évite de relancer si déjà en cours de lecture)
func play_music(force_restart: bool = false) -> void:
	var stream: AudioStream = load("res://Assets/Music/"+chosen_song+".mp3")
	if stream == null:
		stop_music()
		return
	
	if music_player.stream == stream and music_player.playing and not force_restart:
		return
	
	music_player.stream = stream
	music_player.play()

# Arrête la lecture de la musique
func stop_music() -> void:
	music_player.stop()

# Ajuste le niveau d'amplification des basses fréquences (32 Hz et 100 Hz) selon la tension du combat
func set_bass_boost(value: float = 0.):
	if not eq_effect:
		return
	
	var min_db = -2.0    # Niveau standard sans boost
	var max_db = 18.0   # Amplification maximale (+18 dB)
	
	var boost_db_32 = lerp(min_db, max_db, value)
	var boost_db_100 = lerp(min_db, max_db/1.3, value)
	
	# Application des gains en décibels sur les bandes de basses
	eq_effect.set_band_gain_db(0, boost_db_32) # Bande 32 Hz
	eq_effect.set_band_gain_db(1, boost_db_100) # Bande 100 Hz

# Règle le volume audio (échelle linéaire de 0.0 à 1.0 convertie en dB)
func set_volume(volume_linear: float) -> void:
	music_player.volume_db = linear_to_db(clamp(volume_linear, 0.0, 1.0))
