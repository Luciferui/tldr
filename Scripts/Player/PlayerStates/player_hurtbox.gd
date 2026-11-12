## Zone de réception des coups spécifique au joueur (PlayerHurtbox).
## Calcule la direction et l'amplitude du knockback selon l'attaque reçue et transmet les dégâts au joueur.
class_name PlayerHurtbox
extends Hurtbox

@export var state_machine: StateMachine
var player: CharacterBody2D

# Récupère la référence vers le joueur propriétaire
func _ready() -> void:
	super._ready()
	player = owner

# Traite l'impact d'une Hitbox ennemie, calcule le recul (knockback) et appelle takeAttack
func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox.current_attack == null:
		return
	if not hitbox.get_owner()==owner:
		var pos : Vector2 = Vector2(0,0)
		var orientation : int = 1
		if hitbox.current_attack.orientation_knockback != Vector2(0,0):
			orientation = hitbox.getOwnerOrientation()
		if hitbox.current_attack.relative_knockback_factor != 0:
			pos = hitbox.getOwnerPosition()
		player.takeAttack(hitbox.current_attack, pos ,orientation)

## Active les formes de collision de la hurtbox
func activate_hurtbox() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", false)

## Désactive les formes de collision de la hurtbox (invulnérabilité)
func deactivate_hurtbox() -> void:
	for child in get_children():
		if child is CollisionShape2D:
			child.set_deferred("disabled", true)
