extends Node

var p1_spells := [-1, -1, -1]
var p2_spells := [-1, -1, -1]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func distribute_spells(p1_selected_spells, p2_selected_spells) -> void:
	p1_spells = p1_selected_spells
	p2_spells = p2_selected_spells

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
