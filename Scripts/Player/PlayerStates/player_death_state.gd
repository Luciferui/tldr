class_name PlayerDeathState
extends PlayerState

signal death_finished

@export var animation_name: StringName = &"death"

var finished: bool = false


func enter() -> void:
	finished = false
	player.velocity = Vector2.ZERO

	if not player.sprite.animation_finished.is_connected(
		_on_animation_finished
	):
		player.sprite.animation_finished.connect(
			_on_animation_finished
		)

	player.sprite.play(animation_name)


func process_input(_event: InputEvent) -> State:
	return null


func process_physics(delta: float) -> State:
	super.process_physics(delta)
	player.velocity.x = 0.0
	return null


func _on_animation_finished() -> void:
	if finished or player.sprite.animation != animation_name:
		return

	finished = true
	death_finished.emit()
