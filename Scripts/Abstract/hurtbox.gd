# hurtbox.gd
class_name Hurtbox
extends Area2D

signal hit_received(attack: AttackData)


func _ready() -> void:
	collision_layer = 4
	collision_mask = 2
	area_entered.connect(_on_area_entered)


func _on_area_entered(area: Area2D) -> void:
	var hitbox = area as Hitbox
	if hitbox.current_attack == null:
		return
	hit_received.emit(hitbox.current_attack)
