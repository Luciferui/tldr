## État de course / marche au sol du joueur : applique la vitesse de déplacement au sol (move_speed),
## permet le saut, l'attaque, l'esquive et la traversée descendante de plateforme.
class_name PlayerWalkState
extends PlayerState

@export var animation_name: String = "walk"
@export var move_speed: float = 200.0
@export var idle_state: State
@export var jump_state: State
@export var fall_state: State
@export var attack_state: State
@export var dodge_state : State

# Lance l'animation de marche, réinitialise l'esquive et conserve l'orientation du sprite
func enter() -> void:
	player.set_can_dodge(true)
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip

# Intercepte les commandes d'action prioritaires durant la course
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed(player.jump_action) and player.is_on_floor():
		return jump_state
	if Input.is_action_just_pressed(player.light_attack_action) or Input.is_action_just_pressed(player.heavy_attack_action):
		return attack_state
	if Input.is_action_just_pressed(player.dodge_action) and player.get_can_dodge():
		return dodge_state
	if Input.is_action_pressed(player.down_action) and player.is_on_floor():
		drop_through_platform()
		return fall_state
	return null

# Applique la vitesse de marche et repasse en idle si l'entrée est neutre ou en chute si plus au sol
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	determine_sprite_flip()
	
	var dir = get_movement_direction()
	player.velocity.x = dir * move_speed
	
	if dir == 0:
		return idle_state
	if not player.is_on_floor():
		return fall_state
	return null

## Désactive le calque de plateforme semi-solide et applique une impulsion vers le bas
func drop_through_platform() -> void:
	player.set_collision_mask_value(3, false)
	player.velocity.y = maxf(player.velocity.y, 100.0)
