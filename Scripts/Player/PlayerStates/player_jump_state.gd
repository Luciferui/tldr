## État d'impulsion de saut du joueur : applique la vitesse verticale ascendante (jump_force),
## gère le contrôle horizontal en l'air et bascule vers l'état de chute au point culminant.
class_name PlayerJumpState
extends PlayerState

@export var animation_name: String = "jump"
@export var jump_force: float = -400.0
@export var air_move_speed: float = 150.0
@export var fall_state: State
@export var attack_state : State
@export var dodge_state: State

# Lance l'animation de saut et applique l'impulsion vers le haut
func enter() -> void:
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
	player.velocity.y = jump_force

# Intercepte l'esquive, les attaques aériennes et la traversée descendante de plateforme
func process_input(_event: InputEvent) -> State:
	if Input.is_action_just_pressed(player.dodge_action) and player.get_can_dodge():
		return dodge_state
	elif Input.is_action_just_pressed(player.heavy_attack_action) or Input.is_action_just_pressed(player.light_attack_action):
		return attack_state
	if Input.is_action_pressed(player.down_action):
		player.set_collision_mask_value(3,false)
	else:
		player.set_collision_mask_value(3,true)
	return null

# Applique la vitesse horizontale en l'air et bascule en chute dès que la vitesse verticale devient positive
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	determine_sprite_flip()
	
	var dir = get_movement_direction()
	player.velocity.x = dir * air_move_speed
	
	if player.velocity.y >= 0:
		return fall_state
	return null
