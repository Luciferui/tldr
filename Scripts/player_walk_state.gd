class_name PlayerWalkState
extends PlayerState

@export var animation_name: String = "walk"
@export var move_speed: float = 200.0
@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var punch_state: State
@export var kick_state: State

func enter() -> void:
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed("jump") and player.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed("punch"):
		return punch_state
	if Input.is_action_just_pressed("kick"):
		return kick_state
	return null

func process_physics(delta: float) -> State:
	super.process_physics(delta)
	determine_sprite_flip()
	
	var dir = get_movement_direction()
	player.velocity.x = dir * move_speed
	
	if dir == 0:
		return idle_state
	if not player.is_on_floor():
		return fall_state
	return null
