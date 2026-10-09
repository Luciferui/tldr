extends Node

@onready var sprite: AnimatedSprite2D = $"Gameover Sprite"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play(&"gameover")
	await get_tree().create_timer(10.0).timeout
	get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")

func _back_to_menus() -> void:
	if Input.is_action_just_pressed("p1_heavy"):
		get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_back_to_menus()
