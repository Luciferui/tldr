## Ressource de données définissant les paramètres d'une attaque (dégâts, hitstun, knockback, animation, timings).
class_name AttackData
extends Resource

@export var attack_name: StringName
@export var hitbox_name: StringName
@export var animation_name: StringName
@export var total_frame_count: int
@export var damage: int = 10
@export var hitstun: int = 10
@export var attack_timing: Array[int] = [0]
## Knockback vectoriel absolu (indépendant de l'orientation)
@export var absolute_knockback: Vector2 = Vector2(0,0)
## Knockback vectoriel relatif gauche/droite selon l'orientation de l'attaquant
@export var orientation_knockback: Vector2 = Vector2(0,0)
## Facteur de knockback sur l'axe entre l'attaquant et la cible
@export var relative_knockback_factor: float = 0
@export var hit_sound: AudioStream

@export var is_moving: bool = false
@export var move_amplitude : float = 0
