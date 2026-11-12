## État de repos au sol du joueur : permet le saut, l'attaque, l'esquive, la traversée de plateformes
## et transitionne vers la marche si une touche directionnelle est maintenue.
class_name PlayerIdleState
extends PlayerState

@export var animation_name: String = "idle"
@export var walk_state: State
@export var jump_state: State
@export var attack_state: State
@export var dodge_state: State
@export var fall_state: State

var attackActions: Array[StringName]

# Réinitialise la disponibilité de l'esquive et lance l'animation de repos
func enter() -> void:
	super.enter()
	player.set_can_dodge(true)
	attackActions = [player.heavy_attack_action,player.light_attack_action]
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip

# Intercepte les commandes d'action (saut, attaque, esquive, descente de plateforme)
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed(player.jump_action) and player.is_on_floor():
		return jump_state
	if attackActions.any(func(action): return Input.is_action_just_pressed(action)):
		return attack_state
	if Input.is_action_just_pressed(player.dodge_action) and player.get_can_dodge():
		return dodge_state
	if Input.is_action_pressed(player.down_action) and player.is_on_floor():
		drop_through_platform()
		return fall_state
	return null

# Maintient la vitesse horizontale à zéro et bascule vers la marche en cas de déplacement
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	player.velocity.x = 0
	determine_sprite_flip()
	
	if get_movement_direction() != 0:
		return walk_state
	return null

## Désactive le calque de plateforme semi-solide et applique une impulsion vers le bas
func drop_through_platform() -> void:
	player.set_collision_mask_value(3, false)
	player.velocity.y = maxf(player.velocity.y, 100.0)
