class_name PlayerPainState
extends PlayerState

@export var animation_name: String = "pain"
@export var knockback_force: float = 300.0
@export var hurtbox: PlayerHurtbox
@export var idle_state: State

var anim_finished: bool = false

func enter() -> void:
	anim_finished = false
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
	apply_knockback()
	
	if not player.sprite.animation_finished.is_connected(_on_animation_finished):
		player.sprite.animation_finished.connect(_on_animation_finished)

func apply_knockback() -> void:
	if hurtbox and hurtbox.hitting_area:
		var attack_dir = (player.global_position - hurtbox.hitting_area.global_position).normalized()
		player.velocity.x = attack_dir.x * knockback_force

func exit(new_state: State = null) -> void:
	super.exit(new_state)
	player.velocity.x = 0

func _on_animation_finished() -> void:
	if player.sprite.animation == animation_name:
		anim_finished = true

func process_physics(delta: float) -> State:
	super.process_physics(delta)
	if anim_finished:
		return idle_state
	return null
