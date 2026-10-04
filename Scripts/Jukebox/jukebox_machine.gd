extends Node

# Référence vers le nœud audio qui persiste entre les scènes
var music_player: AudioStreamPlayer
var chosen_song: String = "Volcanic Bomb"

func _ready() -> void:
	# Instanciation et ajout de l'AudioStreamPlayer
	music_player = AudioStreamPlayer.new()
	# Canal 'Music' dans le Mixeur Audio (optionnel mais recommandé)
	music_player.bus = "Music" 
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

# Régler le volume (entre 0.0 et 1.0)
func set_volume(volume_linear: float) -> void:
	music_player.volume_db = linear_to_db(clamp(volume_linear, 0.0, 1.0))
