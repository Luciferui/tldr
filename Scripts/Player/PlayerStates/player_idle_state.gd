class_name PlayerIdleState
extends PlayerState

@export var animation_name: String = "idle"
@export var walk_state: State
@export var jump_state: State
@export var attack_state: State

func enter() -> void:
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
	
#func exit(state : State = null) -> void:
#	print("exit idle")

func process_input(event: InputEvent) -> State:
	if Input.is_action_just_pressed(player.jump_action) and player.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed(player.heavy_attack_action) or Input.is_action_just_pressed(player.light_attack_action):
		return attack_state
	return null

func process_physics(delta: float) -> State:
	super.process_physics(delta)
	player.velocity.x = 0
	determine_sprite_flip()
	
	if get_movement_direction() != 0:
		return walk_state
	return null
