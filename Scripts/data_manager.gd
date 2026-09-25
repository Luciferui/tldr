extends Node

var spellChoice: Array = [[], []]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func distribute_spells(p1_selected_spells: Array[SpellData], p2_selected_spells: Array[SpellData]) -> void:
	spellChoice[0] = p1_selected_spells
	spellChoice[1] = p2_selected_spells
	print(spellChoice)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
