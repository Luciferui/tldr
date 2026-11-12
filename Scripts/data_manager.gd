# Gestionnaire de données persistant (Autoload) : stocke les sorts sélectionnés par les joueurs et le vainqueur du match.
extends Node

var spellChoice: Array = [[], []]
var player_won := -1

# Initialisation du gestionnaire
func _ready() -> void:
	pass

# Reçoit les sorts choisis par chaque joueur et les trie par ordre croissant de coût
func distribute_spells(p1_selected_spells: Array[SpellData], p2_selected_spells: Array[SpellData]) -> void:
	spellChoice[0] = _sorted_by_cost(p1_selected_spells)
	spellChoice[1] = _sorted_by_cost(p2_selected_spells)

# Trie la liste des sorts par coût croissant (du moins cher au plus cher)
func _sorted_by_cost(spells: Array[SpellData]) -> Array[SpellData]:
	var sorted := spells.duplicate()
	sorted.sort_custom(func(a: SpellData, b: SpellData) -> bool: return a.required_combo < b.required_combo)
	return sorted

# Traitement par frame
func _process(_delta: float) -> void:
	pass
