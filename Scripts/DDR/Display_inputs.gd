extends Control


# 1. Associez vos actions à leurs textures
@export var input_textures: Dictionary = {
	"p1_jump": preload("res://Assets/ddr_textures/up.png"),
	"p1_down": preload("res://Assets/ddr_textures/down.png"),
	"p1_left": preload("res://Assets/ddr_textures/left.png"),
	"p1_right": preload("res://Assets/ddr_textures/right.png"),
	"p1_lightatk": preload("res://Assets/ddr_textures/light.png"),
	"p1_heavyatk": preload("res://Assets/ddr_textures/heavy.png"),
	"p2_jump": preload("res://Assets/ddr_textures/up.png"),
	"p2_down": preload("res://Assets/ddr_textures/down.png"),
	"p2_left": preload("res://Assets/ddr_textures/left.png"),
	"p2_right": preload("res://Assets/ddr_textures/right.png"),
	"p2_lightatk": preload("res://Assets/ddr_textures/light.png"),
	"p2_heavyatk": preload("res://Assets/ddr_textures/heavy.png")
}

# 2. Fonction pour régénérer la file d'icônes
func display_combo_queue(combo_list: Array[String]) -> void:
	# On vide les anciennes icônes
	for child in get_children():
		child.queue_free()
	
	# On crée une case TextureRect pour chaque entrée de la liste
	for action_name in combo_list:
		if input_textures.has(action_name):
			var icon = TextureRect.new()
			icon.texture = input_textures[action_name]
			
			# Configuration pour garder de belles proportions
			#icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
			icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
			icon.custom_minimum_size = Vector2(256, 256) # Ajustez la taille voulue en pixels
			
			add_child(icon)
