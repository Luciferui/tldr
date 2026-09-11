class_name Hitbox
extends Area2D

@export var damage := 10
@onready var collisionShape: CollisionShape2D = $Kick

func _init() -> void:
	collision_layer = 2
	collision_mask = 0

func activateCollisionShape(name : String) -> void :
	collisionShape.disabled = false
	
func disableCollisionShape(name : String) -> void :
	collisionShape.disabled = true
