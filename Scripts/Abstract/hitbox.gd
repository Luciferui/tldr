class_name Hitbox
extends Area2D

var collision_shape_dict: Dictionary[StringName, CollisionShape2D] = {}

var current_attack: AttackData = null

func _ready() -> void:
	collision_layer = 2
	collision_mask = 4
	for child in get_children():
		if child is CollisionShape2D:
			collision_shape_dict[child.name] = child

func activateAttack(attack: AttackData) -> void:
	##active l'attaque attack:AttackData et la CollisionArea de nom attack.hitbox_name
	if current_attack!=null:
		deactivateAttack()
	if attack == null:
		return
	var shape = collision_shape_dict.get(attack.hitbox_name)
	if shape == null:
		push_warning(
			"Attack '%s' references unknown hitbox shape '%s'"
			% [attack.attack_name, attack.hitbox_name]
		)
		return
	current_attack = attack
	shape.set_deferred("disabled", false)
	
func deactivateAttack() -> void:
	if current_attack == null:
		return
	var shape = collision_shape_dict.get(current_attack.hitbox_name)
	if shape != null:
		shape.set_deferred("disabled", true)
	current_attack = null
