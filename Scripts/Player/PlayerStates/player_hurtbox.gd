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
		player.takeAttack(hitbox.current_attack, hitbox.getOwnerPosition(),hitbox.getOwnerOrientation())

func activate_hurtbox() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", false)

func deactivate_hurtbox() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
