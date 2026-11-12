# Affichage de la jauge et du compteur de DDHealth ainsi que de l'avatar du joueur dans l'interface.
extends Node

# Positionne l'affichage et applique le shader de coloration bleue pour le joueur 2
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
		
		# Application du shader bleu sur le portrait du joueur 2
		var mat = ShaderMaterial.new()
		mat.shader = preload("res://Scripts/Player/blue_filter.gdshader")
		mat.set_shader_parameter("target_color", Color(1.0, 0.0, 0.0)) # Couleur rouge à remplacer
		mat.set_shader_parameter("replace_color", Color(0.0, 0.4, 1.0)) # Nouvelle teinte bleue
		mat.set_shader_parameter("tolerance", 0.5)
		$Face.material = mat
		
	elif player.player_id == 3:
		self.position = Vector2(0, -150)
	
	$RichTextLabel.text = "0"

# Met à jour la valeur numérique affichée du compteur de dégâts
func update_ddhealth(health: int):
	$RichTextLabel.text = str(health)
