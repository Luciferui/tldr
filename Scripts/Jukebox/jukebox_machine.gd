extends Node

# Référence vers le nœud audio qui persiste entre les scènes
var music_player: AudioStreamPlayer
var chosen_song: String = "Volcanic Bomb"
var bus_index: int
var eq_effect: AudioEffectEQ

func _ready() -> void:
	# Instanciation et ajout de l'AudioStreamPlayer
	music_player = AudioStreamPlayer.new()
	# Canal 'Music' dans le Mixeur Audio (optionnel mais recommandé)
	music_player.bus = "Music" 
	
	bus_index = AudioServer.get_bus_index("Music")
	eq_effect = AudioServer.get_bus_effect(bus_index, 0) as AudioEffectEQ
	
	add_child(music_player)

# Fonction principale pour jouer une musique
func play_music(force_restart: bool = false) -> void:
	var stream: AudioStream = load("res://Assets/Music/"+chosen_song+".mp3")
	if stream == null:
		stop_music()
		return
	
	# Si la même musique joue déjà, on ne la relance pas depuis le début
	if music_player.stream == stream and music_player.playing and not force_restart:
		return
	
	music_player.stream = stream
	music_player.play()

# Arrêter la musique
func stop_music() -> void:
	music_player.stop()

func set_bass_boost(value: float = 0.): #le signal donne la ddhealth dont on ne s'occupe pas
	if not eq_effect:
		return# Sur un AudioEffectEQ6 :
	# Bande 0 = ~32 Hz, Bande 1 = ~100 Hz (les vraies basses)
	# Le gain s'exprime en décibels (dB), généralement entre -60 dB et +24 dB.
	
	var min_db = -2.0    # Niveau normal
	var max_db = 18.0   # Boost maximal (+18 dB)
	
	var boost_db_32 = lerp(min_db, max_db, value)
	var boost_db_100 = lerp(min_db, max_db/1.3, value)
	
	# Augmente le gain des basses sous 32Hz et 100Hz
	eq_effect.set_band_gain_db(0, boost_db_32) # 32 Hz
	eq_effect.set_band_gain_db(1, boost_db_100) # 100 Hz

# Régler le volume (entre 0.0 et 1.0)
func set_volume(volume_linear: float) -> void:
	music_player.volume_db = linear_to_db(clamp(volume_linear, 0.0, 1.0))
