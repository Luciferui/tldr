class_name PlayerDyingState
extends PlayerState

@export var animation_name: StringName = &"dying"

func enter() -> void:
	player.velocity.x = 0.0
	player.sprite.play(animation_name)

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	super.process_physics(delta)
	player.velocity.x = 0.0
	return null

func exit(new_state: State = null) -> void:
	super.exit(new_state)
