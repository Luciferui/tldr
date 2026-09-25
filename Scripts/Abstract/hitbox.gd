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

func setCurrentAttack(attack: AttackData) ->void:
	##selectionne l'attaque actuelle pour activation plus tard
	if current_attack!=null :
		push_warning(
			"Attack '%s' set while other attack still current"
			% [attack.attack_name]
		)
	current_attack = attack

func flipActivationAttack(attack : AttackData) ->void:
	##flip l'état d'activation d'une attaque (travaille avec player_attack_state.attack_timing)
	var shape = collision_shape_dict.get(current_attack.hitbox_name)
	if shape == null:
		push_warning(
			"Attack '%s' references unknown hitbox shape '%s'"
			% [attack.attack_name, attack.hitbox_name]
		)
		return
	if shape.disabled:
		shape.set_deferred("disabled",false)
	else:
		shape.set_deferred("disabled",true)
	
func deactivateAttack() -> void:
	if current_attack == null:
		return
	var shape = collision_shape_dict.get(current_attack.hitbox_name)
	if shape != null:
		shape.set_deferred("disabled", true)
	current_attack = null
