extends Area2D

@export var Player1: Player
@export var Player2: Player

@onready var announcements: RichTextLabel = $"../Announcements/RichTextLabel"
@onready var gong_sound: AudioStreamPlayer = $GongSound

var announcement_tween: Tween
var current_announcement: String = ""
var waiting_frames: int = -1

var places_list: Array = [
	Vector2(-275, 0.),
	Vector2(-185, -135),
	Vector2(200, -25),
	Vector2(-271, 75),
	Vector2(150, 100)
]

# Gestion du volume de la musique
var music_bus_index: int = -1
var normal_music_volume: float = 0.0
var previous_ko_state: bool = false


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	area_entered.connect(_on_area_entered)

	announcements.visible = false
	announcements.modulate.a = 0.0
	announcements.scale = Vector2(0.75, 0.75)

	# Récupération du bus Music et de son volume initial
	music_bus_index = AudioServer.get_bus_index("Music")

	if music_bus_index != -1:
		normal_music_volume = AudioServer.get_bus_volume_db(music_bus_index)

	respawn_gong()


func _exit_tree() -> void:
	# Restaurer le volume si la scène est quittée
	if music_bus_index != -1:
		AudioServer.set_bus_volume_db(
			music_bus_index,
			normal_music_volume
		)


func _process(_delta: float) -> void:
	update_announcements()

	if waiting_frames != -1:
		waiting_frames += 1

	if waiting_frames == 60 * 10:
		respawn_gong()
		waiting_frames = -1


func _on_area_entered(area: Area2D) -> void:
	if not visible:
		return

	if not area is Hitbox:
		return

	var attacker = (area as Hitbox).attacker
	var victim: Player = null

	if attacker == Player1:
		victim = Player2
	elif attacker == Player2:
		victim = Player1
	else:
		return

	if victim.get_node("RescueController").begin_rescue():
		hide_gong()


func hide_gong() -> void:
	visible = false
	set_deferred("monitoring", false)
	waiting_frames = 0


func respawn_gong() -> void:
	var previous_pos = position
	var current_place = places_list.pick_random()

	while current_place == previous_pos:
		current_place = places_list.pick_random()

	position = current_place
	visible = true
	set_deferred("monitoring", true)
	$AnimationPlayer.play("skull_idling")


func update_announcements() -> void:
	var rescue1 = Player1.get_node("RescueController")
	var rescue2 = Player2.get_node("RescueController")

	var p1_health = Player1.ddhealth
	var p2_health = Player2.ddhealth

	# Gestion du gong et du volume de la musique
	var someone_ko = rescue1.rescue_active or rescue2.rescue_active
	update_ko_audio(someone_ko)

	if rescue1.rescue_active:
		show_announcement("P1 is KO\n Make " + str(p1_health) + "inputs to survive")
	elif rescue2.rescue_active:
		show_announcement("P2 is KO\n Make " + str(p2_health) + " inputs to survive")
	else:
		hide_announcement()


func update_ko_audio(is_ko: bool) -> void:
	# Éviter de rejouer le gong à chaque frame
	if is_ko == previous_ko_state:
		return

	previous_ko_state = is_ko

	if is_ko:
		# Jouer le gong
		if gong_sound.stream != null:
			gong_sound.play()

		# Baisser la musique de 3 dB
		if music_bus_index != -1:
			AudioServer.set_bus_volume_db(
				music_bus_index,
				normal_music_volume - 10.0
			)
	else:
		# Restaurer le volume normal
		if music_bus_index != -1:
			AudioServer.set_bus_volume_db(
				music_bus_index,
				normal_music_volume
			)


func show_announcement(message: String) -> void:
	if current_announcement == message and announcements.visible:
		return

	current_announcement = message

	if announcement_tween and announcement_tween.is_running():
		announcement_tween.kill()

	announcements.text = message
	announcements.visible = true

	announcements.modulate.a = 0.0
	announcements.scale = Vector2(0.75, 0.75)

	announcement_tween = create_tween()
	announcement_tween.set_parallel(true)

	announcement_tween.tween_property(
		announcements, "modulate:a", 1.0, 0.2
	)

	announcement_tween.tween_property(
		announcements, "scale", Vector2.ONE, 0.25
	).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func hide_announcement() -> void:
	if not announcements.visible:
		return

	current_announcement = ""

	if announcement_tween and announcement_tween.is_running():
		announcement_tween.kill()

	announcement_tween = create_tween()
	announcement_tween.set_parallel(true)

	announcement_tween.tween_property(
		announcements, "modulate:a", 0.0, 0.2
	)

	announcement_tween.tween_property(
		announcements, "scale", Vector2(0.9, 0.9), 0.2
	)

	announcement_tween.chain().tween_callback(
		func(): announcements.visible = false
	)
