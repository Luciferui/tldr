extends Node

var spellChoice: Array = [[], []]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func distribute_spells(p1_selected_spells: Array[SpellData], p2_selected_spells: Array[SpellData]) -> void:
	spellChoice[0] = _sorted_by_cost(p1_selected_spells)
	spellChoice[1] = _sorted_by_cost(p2_selected_spells)
	#print(spellChoice)

# Trie par coût croissant : spellChoice[p][0] = sort le moins cher (c1), [2] = le plus cher (c3),
# quel que soit l'ordre dans lequel le joueur les a placés dans ses slots.
func _sorted_by_cost(spells: Array[SpellData]) -> Array[SpellData]:
	var sorted := spells.duplicate()
	sorted.sort_custom(func(a: SpellData, b: SpellData) -> bool: return a.required_combo < b.required_combo)
	return sorted

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
