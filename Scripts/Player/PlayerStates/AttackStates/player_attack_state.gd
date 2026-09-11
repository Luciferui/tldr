class_name PlayerAttackState
extends PlayerState

@export var animation_name: String
@export var idle_state: PlayerState
@export var walk_state: PlayerState
@export var pain_state: PlayerState
@export var hitbox: Hitbox
@export var totalFrameCount : int ##durée en nb frames de l'attaque

var frameCount : int ##nb frames depuis le début de l'attaque
var attack_finished: bool = false
# arrêt du personnage jusqu'a la fin de l'animation

func enter() -> void:
	frameCount = 0
	attack_finished = false
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
	player.velocity.x = 0
	
	if hitbox:
		if sprite_flip:
			hitbox.scale.x = -1.0
			#flip l'axe x de la hitbox (le 0 du hitbox doit correspondre au milieu du Player)
		else:
			hitbox.scale.x = 1.0
	
	#if not player.sprite.animation_finished.is_connected(_on_animation_finished):
		#player.sprite.animation_finished.connect(_on_animation_finished)
		##on connecte la fin de l'animation à la fin de l'attaque. À changer !!! Il faut que les 
		##framerate physics et animation soient les mêmes
#
#func _on_animation_finished() -> void:
	###Met le bool attack_finished à true quand l'animation de l'attaque est finie
	#if player.sprite.animation == animation_name:
		#attack_finished = true

func process_physics(delta: float) -> State:
	print("here")
	if attack_finished:
		print("finished")
		#attaque finie de manière standard
		if get_movement_direction() != 0:
			return walk_state
		return idle_state
	print(frameCount)
	frameCount += 1
	if frameCount >= totalFrameCount:
		attack_finished = true
	
	return null
