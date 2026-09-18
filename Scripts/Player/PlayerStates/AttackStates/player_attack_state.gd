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
var currentAttackName: String
var animation_name: String

func enter() -> void:
	
	selectAttack()
	
	frameCount = 0
	attack_finished = false
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
	player.velocity.x = 0
	
	if hitbox:
		if sprite_flip:
			hitbox.scale.x = -1.0
			#flip l'axe x de la hitbox pour faire l'attaque dans l'autre sens
		else:
			hitbox.scale.x = 1.0
		
func selectAttack() -> void :
	if Input.is_action_just_pressed("kick"):
		currentAttackName = "kick"
		animation_name = currentAttackName
		totalFrameCount = 60
		hitbox.activateCollisionShape(currentAttackName)
	elif Input.is_action_just_pressed("punch"):
		currentAttackName = "punch"
		animation_name = currentAttackName
		totalFrameCount = 36
		hitbox.activateCollisionShape(currentAttackName)

func process_physics(delta: float) -> State:
	if attack_finished:
		hitbox.disableCollisionShape(currentAttackName)
		#attaque finie de manière standard
		if get_movement_direction() != 0:
			return walk_state
		return idle_state
	frameCount += 1
	if frameCount >= totalFrameCount:
		attack_finished = true
	
	return null
