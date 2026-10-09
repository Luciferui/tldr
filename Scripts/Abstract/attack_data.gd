class_name AttackData
extends Resource

@export var attack_name: StringName
@export var hitbox_name: StringName
@export var animation_name: StringName
@export var total_frame_count: int
@export var damage: int = 10
@export var hitstun: int = 10
@export var attack_timing: Array[int] = [0]
@export var absolute_knockback: Vector2 = Vector2(0,0)
##knockback vectoriel absolu
@export var orientation_knockback: Vector2 = Vector2(0,0)
##knockback vectoriel relatif gauche/droite
@export var relative_knockback_factor: float = 0
##facteur de knockback sur l'axe entre les hitbox
