class_name PlayerJumpState
extends PlayerState

@export var animation_name: String = "jump"
@export var jump_force: float = -400.0
@export var air_move_speed: float = 150.0
@export var fall_state: State

func enter() -> void:
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
	player.velocity.y = jump_force

#func process_input(event: InputEvent) -> State:
#	if Input.is_action_just_released("jump") and player.velocity.y > 0:
#		player.velocity.y = 0.0
#	return null

func process_physics(delta: float) -> State:
	super.process_physics(delta)
	
	var dir = get_movement_direction()
	player.velocity.x = dir * air_move_speed
	
	if player.velocity.y >= 0:
		return fall_state
	return null
