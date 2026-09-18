class_name Hitbox
extends Area2D

@export var damage := 10
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	collision_layer = 2
	collision_mask = 0

func activateCollisionShape(name : String) -> void :
	collision_shape_2d.set_deferred("disabled",false)
	
func disableCollisionShape(name : String) -> void :
	collision_shape_2d.set_deferred("disabled",true)
