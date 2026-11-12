## État de chute aérienne du joueur : gère le déplacement horizontal dans les airs,
## les attaques aériennes, l'esquive et la traversée des plateformes semi-solides (down action).
class_name PlayerFallState
extends PlayerState

@export var animation_name: String = "fall"
@export var air_move_speed: float = 150.0
@export var idle_state: State
@export var walk_state: State
@export var dodge_state: State
@export var attack_state: State

# Lance l'animation de chute et conserve l'orientation du sprite
func enter() -> void:
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip

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

# Applique la vitesse horizontale aérienne et détecte l'atterrissage au sol
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	determine_sprite_flip()
	
	var dir = get_movement_direction()
	player.velocity.x = dir * air_move_speed
	
	if player.is_on_floor():
		if dir != 0:
			return walk_state
		return idle_state
	return null
