## État d'attaque du joueur : gère les attaques terrestres et aériennes (coups légers et lourds),
## l'activation cadencée de la Hitbox et les impulsions de mouvement associées.
class_name PlayerAttackState
extends PlayerState

@export var idle_state: PlayerState
@export var walk_state: PlayerState
@export var pain_state: PlayerState
@export var hitbox: Hitbox
@export var totalFrameCount : int ## Durée totale de l'attaque en nombre de frames
var spellLauncher : Node2D
@export var air_attack_move_speed: float = 75.0

var frameCount : int ## Nombre de frames écoulées depuis le début du coup
var attack_finished: bool = false
var animation_name: String
var attack_timing : Array[int] = [0]

var currentAttack: AttackData
var kick_attack : AttackData
var punch_attack : AttackData
var air_heavy_attack : AttackData
var air_light_attack : AttackData

var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

# Précharge les ressources d'attaque (coups au sol et en l'air)
func _ready() -> void:
	super._ready()
	kick_attack = load("res://Attacks/kick.tres")
	punch_attack = load("res://Attacks/punch.tres")
	air_heavy_attack = load("res://Attacks/air_heavy.tres")
	air_light_attack = load("res://Attacks/air_light.tres")

# Détermine l'attaque à exécuter, oriente le sprite/hitbox et applique la vitesse initiale du coup
func enter() -> void:
	selectAttack()
	
	frameCount = 0
	attack_finished = false
	player.sprite.play(currentAttack.animation_name)
	player.sprite.flip_h = sprite_flip
	if currentAttack.is_moving:
		player.velocity.x = (-1 if sprite_flip else 1)*currentAttack.move_amplitude
	else:
		player.velocity.x = 0
	
	if hitbox:
		if sprite_flip:
			hitbox.scale.x = -1.0
		else:
			hitbox.scale.x = 1.0

# Sélectionne la ressource d'attaque adaptée selon la touche (légère/lourde) et la position (sol/air)
func selectAttack() -> void :
	if Input.is_action_just_pressed(player.heavy_attack_action):
		if player.is_on_floor():
			currentAttack = kick_attack
		else:
			currentAttack = air_heavy_attack
	elif Input.is_action_just_pressed(player.light_attack_action):
		if player.is_on_floor():
			currentAttack = punch_attack
		else:
			currentAttack = air_light_attack

	animation_name = currentAttack.animation_name
	totalFrameCount = currentAttack.total_frame_count
	attack_timing = currentAttack.attack_timing
	hitbox.setCurrentAttack(currentAttack)

# Gère la décélération du coup, l'activation/désactivation de la Hitbox aux timings prévus et la sortie
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	if currentAttack.is_moving:
		player.velocity.x = 0.97*player.velocity.x
	elif not player.is_on_floor():
		var dir = get_movement_direction()
		player.velocity.x = air_attack_move_speed * dir
	else:
		player.velocity.x = 0
	if attack_finished:
		hitbox.deactivateAttack()
		if get_movement_direction() != 0:
			return walk_state
		return idle_state
		
	if frameCount in attack_timing:
		hitbox.flipActivationAttack(currentAttack)
	frameCount += 1
	if frameCount >= totalFrameCount:
		attack_finished = true
	
	return null

# Désactive impérativement la Hitbox lors de la transition vers un autre état
func exit(new_state: State = null) -> void:
	if hitbox:
		hitbox.deactivateAttack()
	super.exit(new_state)
