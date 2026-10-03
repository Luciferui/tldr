extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = owner as Player
	if player.player_id%2 == 0:
		self.position = Vector2(-290, -150)
		
	else:
		self.position = Vector2(290, -150)
	
	$RichTextLabel.text = "0"

func update_ddhealt(health: int):
	$RichTextLabel.text = str(health)
