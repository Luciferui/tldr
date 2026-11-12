## Zone de réception des dégâts (Hurtbox).
## Détecte l'entrée d'une Hitbox et transmet les données de l'attaque reçue.
class_name Hurtbox
extends Area2D

signal hit_received(attack: AttackData)

# Configure les calques de collision et connecte la détection de zone.
func _ready() -> void:
	collision_layer = 4
	collision_mask = 2
	area_entered.connect(_on_area_entered)

# Émet un signal lorsqu'une Hitbox contenant une attaque valide touche la zone.
func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox.current_attack == null:
		return
	hit_received.emit(hitbox.current_attack)
