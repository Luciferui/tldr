## État d'esquive / dash : propulse le joueur dans la direction visée et désactive temporairement la Hurtbox (invulnérabilité).
class_name PlayerDodgeState
extends PlayerState

@export var animation_name: String = "dodge"
@export var dodge_force: float = 150.0
@export var total_frame_count: int = 20
@export var idle_state : PlayerState
@export var fall_state: PlayerState
@export var hurtbox : PlayerHurtbox

var frame_count: int = 0
var dir : Vector2

# Lance l'animation, désactive la hurtbox pour l'invincibilité et calcule le vecteur directionnel du dash
func enter() -> void:
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
	hurtbox.deactivate_hurtbox()
	player.set_can_dodge(false)
	dir = Vector2(Input.get_axis(player.left_action,player.right_action),Input.get_axis(player.jump_action,player.down_action)).normalized()

# Applique la courbe de vitesse de l'esquive et repasse en idle ou chute à la fin de la durée
func process_physics(delta: float) -> State:
	super.process_physics(delta)
	player.velocity = (((1.5*float(total_frame_count-frame_count)/total_frame_count)+0.5)**2)*dir*dodge_force
	if frame_count >= total_frame_count:
		frame_count = 0
		if player.is_on_floor():
			player.set_can_dodge(true)
			return idle_state
		return fall_state
	frame_count += 1
	return null

# Réactive la Hurtbox à la fin de l'esquive pour redevenir vulnérable aux coups
func exit(_new_state : State = null) -> void:
	hurtbox.activate_hurtbox()
