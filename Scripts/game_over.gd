extends Node

@onready var sprite: AnimatedSprite2D = $"Gameover Sprite"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.play(&"gameover")
	if DataManager.player_won%2 == 0:
		$RichTextLabel.text = "Player 1 has won"
	else:
		$RichTextLabel.text = "Player 2 has won"
		
	# Supprimer tous les assets inutiles du player
	$"Player/DDHealthDisplayer".queue_free()
	$"Player/Ddr".queue_free()
	$"Player2/DDHealthDisplayer".queue_free()
	$"Player2/Ddr".queue_free()
	await get_tree().create_timer(10.0).timeout
	get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")
	
		

func _back_to_menus() -> void:
	await get_tree().create_timer(5.0).timeout
	if Input.is_action_just_pressed("p1_heavy"):
		get_tree().change_scene_to_file("res://Scenes/spell_select_menu.tscn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	_back_to_menus()
