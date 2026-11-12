## Zone d'attaque (Hitbox) associée à un attaquant (joueur, sort, etc.).
## Gère l'activation et la désactivation différée des formes de collision selon l'attaque en cours.
class_name Hitbox
extends Area2D

var collision_shape_dict: Dictionary[StringName, CollisionShape2D] = {}

var current_attack: AttackData = null
var attacker : Node2D
@export var dissociated_from_player : bool = false

func _ready() -> void:
	attacker = owner # L'objet attaquant correspond au propriétaire de la scène
	collision_layer = 2
	for child in get_children():
		if child is CollisionShape2D:
			collision_shape_dict[child.name] = child

## Active l'attaque spécifiée et active la forme de collision correspondante
func activateAttack(attack: AttackData) -> void:
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

## Définit l'attaque courante pour une activation ultérieure
func setCurrentAttack(attack: AttackData) ->void:
	if current_attack!=null :
		push_warning(
			"Attack '%s' set while other attack still current"
			% [attack.attack_name]
		)
	current_attack = attack

## Alterne l'activation de la forme de collision (utilisé selon le rythme de l'attaque)
func flipActivationAttack(attack : AttackData) ->void:
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
	
## Désactive la hitbox et libère l'attaque en cours
func deactivateAttack() -> void:
	if current_attack == null:
		return
	var shape = collision_shape_dict.get(current_attack.hitbox_name)
	if shape != null:
		shape.set_deferred("disabled", true)
	current_attack = null

## Retourne la position globale ou locale de l'attaquant
func getOwnerPosition() ->Vector2:
	return attacker.position

## Retourne l'orientation de l'attaquant (-1 pour gauche, 1 pour droite)
func getOwnerOrientation() ->int:
	if attacker.get_sprite_faces_left() :
		return -1
	else:
		return 1
