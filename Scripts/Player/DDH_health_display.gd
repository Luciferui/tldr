extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = owner
	if player.player_id == 0:
		$RichTextLabel.horizontal_alignment = 0
		$RichTextLabel.position = Vector2(-265, -180)
		$Face.position = Vector2(-307, -150)
	elif player.player_id == 1:
		$RichTextLabel.horizontal_alignment = 2
		$RichTextLabel.position = Vector2(100, -180)
		$Face.flip_h = true
		$Face.position = Vector2(305, -150)
		
		# Ajoute le filtre bleue sur la tête
		var mat = ShaderMaterial.new()
		mat.shader = preload("res://Scripts/Player/blue_filter.gdshader")
		mat.set_shader_parameter("target_color", Color(1.0, 0.0, 0.0)) # Rouge à remplacer
		mat.set_shader_parameter("replace_color", Color(0.0, 0.4, 1.0)) # Nouveau bleu
		mat.set_shader_parameter("tolerance", 0.5)
		$Face.material = mat
		
	elif player.player_id == 3:
		self.position = Vector2(0, -150)
	
	$RichTextLabel.text = "0"

func update_ddhealth(health: int):
	$RichTextLabel.text = str(health)
