class_name SpellData
extends Resource

@export var id: StringName
@export var display_name: String = ""
@export_multiline var description: String = ""
@export var icon: Texture2D

@export_range(0, 100) var required_combo: int = 4
@export var damage: float = 10.0
@export var cooldown: float = 2.0
@export var animation_name: StringName


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
