class_name InputCursor
extends Node2D

const REF_SIZE := 290.0      # taille de référence pour laquelle les réglages sont validés
const REF_THICKNESS := 25.0  # épaisseur correspondante

@export var frame_size: Vector2 = Vector2(290, 290):
	set(value):
		frame_size = value
		queue_redraw()
@export var color: Color = Color.WHITE

## Amplitude du tremblement, en fraction de la largeur du cadre
@export_range(0.0, 0.5) var shake_ratio: float = 0.15
## Intensité du shrink/deshrink de réussite
@export_range(0.0, 0.5) var pop_ratio: float = 0.15

var tween: Tween
var flash_tween: Tween
var pulse_tween: Tween
var base_position: Vector2

# Épaisseur calculée automatiquement à partir de la taille
var thickness: float:
	get:
		return REF_THICKNESS * frame_size.x / REF_SIZE

func _ready() -> void:
	base_position = position
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(-frame_size / 2.0, frame_size), color, false, thickness)

func _reset() -> void:
	if tween and tween.is_valid():
		tween.kill()
	if flash_tween and flash_tween.is_valid():
		flash_tween.kill()
	position = base_position
	scale = Vector2.ONE

func play_fail() -> void:
	_reset()
	var d := frame_size.x * shake_ratio
	tween = create_tween()
	for offset in [-d, d, -d * 0.6, d * 0.6, -d * 0.3, 0.0]:
		tween.tween_property(self, "position:x", base_position.x + offset, 0.04)
	flash_tween = create_tween()
	flash_tween.tween_property(self, "self_modulate", Color.WHITE, 0.3).from(Color.RED)

func play_success() -> void:
	_reset()
	tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ONE * (1.0 - pop_ratio), 0.06)
	tween.tween_property(self, "scale", Vector2.ONE * (1.0 + pop_ratio * 0.8), 0.08)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "scale", Vector2.ONE, 0.08)

func start_ready_pulse() -> void:
	if pulse_tween and pulse_tween.is_valid():
		return
	pulse_tween = create_tween().set_loops()
	pulse_tween.tween_property(self, "self_modulate", Color(1, 0.85, 0.2), 0.4)
	pulse_tween.tween_property(self, "self_modulate", Color.WHITE, 0.4)

func stop_ready_pulse() -> void:
	if pulse_tween:
		pulse_tween.kill()
	self_modulate = Color.WHITE
