# Affichage visuel de la file d'attente des inputs DDR sous forme d'icônes (flèches et touches d'attaque).
extends Control

# Dictionnaire associant chaque nom d'action à sa texture d'icône correspondante
@export var input_textures: Dictionary = {
	"p1_jump": preload("res://Assets/ddr_textures/new_textures/up.png"),
	"p1_down": preload("res://Assets/ddr_textures/new_textures/down.png"),
	"p1_left": preload("res://Assets/ddr_textures/new_textures/left.png"),
	"p1_right": preload("res://Assets/ddr_textures/new_textures/right.png"),
	"p1_light": preload("res://Assets/ddr_textures/new_textures/light.png"),
	"p1_heavy": preload("res://Assets/ddr_textures/new_textures/heavy.png"),
	"p2_jump": preload("res://Assets/ddr_textures/new_textures/up.png"),
	"p2_down": preload("res://Assets/ddr_textures/new_textures/down.png"),
	"p2_left": preload("res://Assets/ddr_textures/new_textures/left.png"),
	"p2_right": preload("res://Assets/ddr_textures/new_textures/right.png"),
	"p2_light": preload("res://Assets/ddr_textures/new_textures/light.png"),
	"p2_heavy": preload("res://Assets/ddr_textures/new_textures/heavy.png")
}
@export var icon_size := 256

# Régénère les icônes affichées pour refléter la liste courante des touches attendues
func display_combo_queue(combo_list: Array[String]) -> void:
	# Nettoyage des anciennes icônes
	for child in get_children():
		child.queue_free()
	
	# Création d'un TextureRect par touche de la séquence
	for action_name in combo_list:
		if input_textures.has(action_name):
			var icon = TextureRect.new()
			icon.texture = input_textures[action_name]
			
			# Configuration du format et des dimensions de l'icône
			#icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.custom_minimum_size = Vector2(icon_size, icon_size)
			
			add_child(icon)
