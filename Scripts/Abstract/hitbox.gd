class_name Hitbox
extends Area2D

@export var damage := 10

var collision_shape_dict = {}

func _ready() -> void:
	collision_layer = 2
	collision_mask = 0
	for collision_shape_2d in get_children():
		collision_shape_dict[collision_shape_2d.name] = collision_shape_2d

func activateCollisionShape(name : String) -> void :
	##active la collision du collider de nom name
	collision_shape_dict[name].set_deferred("disabled",false)
	
func disableCollisionShape(name : String) -> void :
	##désactive la collision du collider de nom name
	collision_shape_dict[name].set_deferred("disabled",true)
