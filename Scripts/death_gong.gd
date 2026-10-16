extends Node
@export var Player1: Player
@export var Player2: Player
@export var reload_speed: float = 1.
@onready var announcements: RichTextLabel = $Announcements/RichTextLabel
var announcement_tween: Tween
var current_announcement: String = ""
var is_p1_activated = false
var is_p2_activated = false

func _ready() -> void:
	announcements.visible = false
	announcements.modulate.a = 0.0
	announcements.scale = Vector2(0.75, 0.75)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	update_announcements()
	if is_p1_activated:
		if Input.is_action_just_pressed("p1_light"):
			Player2.get_node("RescueController").begin_rescue()
			is_p1_activated = false
			reset_gong()
	if is_p2_activated:
		if Input.is_action_just_pressed("p2_light"):
			Player1.get_node("RescueController").begin_rescue()
			is_p2_activated = false
			reset_gong()

func update_announcements() -> void:
	var rescue1 = Player1.get_node("RescueController")
	var rescue2 = Player2.get_node("RescueController")

	if rescue1.rescue_active:
		show_announcement("P1 is KO")
	elif rescue2.rescue_active:
		show_announcement("P2 is KO")
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

	announcement_tween.tween_property(
		announcements, "modulate:a", 0.0, 0.2
	)

	announcement_tween.tween_property(
		announcements, "scale", Vector2(0.9, 0.9), 0.2
	)

	announcement_tween.chain().tween_callback(
		func(): announcements.visible = false
	)

func _on_body_entered(area: Node2D) -> void:
	if area == Player1:
		is_p1_activated = true
	if area == Player2:
		is_p2_activated = true

func _on_body_exited(area: Node2D) -> void:
	if area == Player1:
		is_p1_activated = false
	if area == Player2:
		is_p2_activated = false
	
func reset_gong():
	$AnimatedSprite2D.play("down_to_up")
	$AnimatedSprite2D.speed_scale = reload_speed
