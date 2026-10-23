extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = owner
	if player.player_id == 0:
		self.position = Vector2(-290, -150)
		
	elif player.player_id == 1:
		self.position = Vector2(290, -150)
	
	elif player.player_id == 3:
		self.position = Vector2(0, -150)
	
	$RichTextLabel.text = "0"

func update_ddhealth(health: int):
	$RichTextLabel.text = str(health)
