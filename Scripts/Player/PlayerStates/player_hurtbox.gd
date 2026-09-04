class_name PlayerHurtbox
extends Area2D

@export var state_machine: StateMachine
@export var pain_state: State

var hitting_area: Area2D

func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	area_entered.connect(_on_area_entered)

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		hitting_area = area
		engine_slow(0.1, 0.15) # Ralentissement du temps au moment de l'impact
		state_machine.change_state(pain_state)

func engine_slow(scale: float, duration: float) -> void:
	Engine.time_scale = scale
	await get_tree().create_timer(duration * scale).timeout
	Engine.time_scale = 1.0
