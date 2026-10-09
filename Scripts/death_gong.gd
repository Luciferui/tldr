extends Node
@export var Player1: Player
@export var Player2: Player
@export var reload_speed: float = 1.

var is_p1_activated = false
var is_p2_activated = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_p1_activated:
		if Input.is_action_just_pressed("p1_light"):
			Player2.get_node("RescueController").begin_rescue()
			is_p1_activated = false
			reset_gong()
	if is_p2_activated:
		if Input.is_action_just_pressed("p2_light"):
			Player1.get_node("RescueController").begin_rescue()
			is_p2_activated = false
			reset_gong

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
