class_name PlayerDyingState
extends PlayerState

signal dying_finished

@export var animation_name: StringName = &"dying"


# Called when the node enters the scene tree for the first time.
func enter() -> void:
	player.velocity = Vector2.ZERO
	player.sprite.play(animation_name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func process_input(_event: InputEvent) -> State:
	return null
	
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	player.velocity.x = 0.0
	return null
	

func exit(new_state: State = null) -> void:
	super.exit(new_state)		
