class_name PlayerHurtbox
extends Hurtbox

@export var state_machine: StateMachine
var player: Player

func _ready() -> void:
	super._ready()
	player = owner as Player

func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox.current_attack == null:
		return
	if not hitbox.get_owner()==owner:
		player.takeAttack(hitbox.current_attack)

#func engine_slow(scale: float, duration: float) -> void:
#	Engine.time_scale = scale
#	await get_tree().create_timer(duration * scale).timeout
#	Engine.time_scale = 1.0
