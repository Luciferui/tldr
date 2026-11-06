extends Area2D

@export var Player1: Player
@export var Player2: Player
@onready var announcements: RichTextLabel = $"../Announcements/RichTextLabel"

var announcement_tween: Tween
var current_announcement: String = ""
var waiting_frames: int = -1

var places_list: Array = [Vector2(-275, 0.), Vector2(-185, -135), Vector2(200, -25), Vector2(-271, 75), Vector2(150, 100)]

func _ready() -> void:
	collision_layer = 0   # le skull n'a pas besoin d'être détecté par les autres
	collision_mask = 2    # il détecte les Hitbox (layer 2)
	area_entered.connect(_on_area_entered)

	announcements.visible = false
	announcements.modulate.a = 0.0
	announcements.scale = Vector2(0.75, 0.75)
	respawn_gong()

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
		return # hitbox qui n'appartient à aucun des deux joueurs

	if victim.get_node("RescueController").begin_rescue():
		hide_gong()

func hide_gong() -> void:
	visible = false
	set_deferred("monitoring", false) # sinon le skull invisible reste frappable
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

	if rescue1.rescue_active:
		show_announcement("P1 is KO\n Make " + str(p1_health) + "inputs to survive")
	elif rescue2.rescue_active:
		show_announcement("P2 is KO\n Make " + str(p2_health) + " inputs to survive")
	else:
		hide_announcement()

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

	announcement_tween.tween_property(announcements, "modulate:a", 0.0, 0.2)
	announcement_tween.tween_property(announcements, "scale", Vector2(0.9, 0.9), 0.2)

	announcement_tween.chain().tween_callback(func(): announcements.visible = false)
