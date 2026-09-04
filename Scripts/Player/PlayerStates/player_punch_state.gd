class_name PlayerPunchState
extends PlayerState

@export var animation_name: String = "punch"
@export var idle_state: State
@export var walk_state: State
@export var hitbox: Hitbox

var has_attacked: bool = false

func enter() -> void:
	has_attacked = false
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
	
	if hitbox:
		hitbox.scale.x = -1.0 if sprite_flip else 1.0
	
	if not player.sprite.animation_finished.is_connected(_on_animation_finished):
		player.sprite.animation_finished.connect(_on_animation_finished)

func _on_animation_finished() -> void:
	if player.sprite.animation == animation_name:
		has_attacked = true

func process_physics(delta: float) -> State:
	player.velocity.x = 0
	
	if has_attacked:
		if get_movement_direction() != 0:
			return walk_state
		return idle_state
	return null
