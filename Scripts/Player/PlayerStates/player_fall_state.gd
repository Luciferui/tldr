class_name PlayerFallState
extends PlayerState

@export var animation_name: String = "fall"
@export var air_move_speed: float = 150.0
@export var idle_state: State
@export var walk_state: State
@export var dodge_state: State

func enter() -> void:
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
	
func process_input(event: InputEvent) -> State:
#	if Input.is_action_just_released("jump") and player.velocity.y > 0:
#		player.velocity.y = 0.0
	if Input.is_action_just_pressed(player.dodge_action) and player.get_can_dodge():
		return dodge_state
	return null

func process_physics(delta: float) -> State:
	super.process_physics(delta)
	determine_sprite_flip()
	
	var dir = get_movement_direction()
	player.velocity.x = dir * air_move_speed
	
	if player.is_on_floor():
		if dir != 0:
			return walk_state
		return idle_state
	return null
