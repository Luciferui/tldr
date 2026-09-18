class_name PlayerAttackState
extends PlayerState

@export var idle_state: PlayerState
@export var walk_state: PlayerState
@export var pain_state: PlayerState
@export var hitbox: Hitbox
@export var totalFrameCount : int ##durée en nb frames de l'attaque

var frameCount : int ##nb frames depuis le début de l'attaque
var attack_finished: bool = false
# arrêt du personnage jusqu'a la fin de l'animation
var animation_name: String

var currentAttack: AttackData
var kick_attack : AttackData
var punch_attack : AttackData

func _ready() -> void:
	##load les attaques
	super._ready()
	kick_attack = load("res://Attacks/kick.tres")
	punch_attack = load("res://Attacks/punch.tres")

func enter() -> void:
	
	selectAttack()
	
	frameCount = 0
	attack_finished = false
	print(currentAttack.animation_name)
	player.getSprite().play(currentAttack.animation_name)
	player.sprite.flip_h = sprite_flip
	player.velocity.x = 0
	
	if hitbox:
		if sprite_flip:
			hitbox.scale.x = -1.0
			#flip l'axe x de la hitbox pour faire l'attaque dans l'autre sens
		else:
			hitbox.scale.x = 1.0
		
func selectAttack() -> void :
	if Input.is_action_just_pressed(player.heavy_attack_action):
		currentAttack = kick_attack
		animation_name = currentAttack.animation_name
		totalFrameCount = 60
		hitbox.activateAttack(currentAttack)
	elif Input.is_action_just_pressed(player.light_attack_action):
		currentAttack = punch_attack
		animation_name = currentAttack.animation_name
		totalFrameCount = 36
		hitbox.activateAttack(currentAttack)

func process_physics(delta: float) -> State:
	if attack_finished:
		hitbox.deactivateAttack()
		#attaque finie de manière standard
		if get_movement_direction() != 0:
			return walk_state
		return idle_state
	frameCount += 1
	if frameCount >= totalFrameCount:
		attack_finished = true
	
	return null

func exit(new_state: State = null) -> void:
	super.exit(new_state)
