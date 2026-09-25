class_name PlayerPainState
extends PlayerState

@export var animation_name: String = "pain"
@export var knockback_force: float = 300.0
@export var hurtbox: PlayerHurtbox
@export var idle_state: State

var stun_finished: bool = false
var frame_count : int
var total_frame_count : int = 0

func enter() -> void:
	stun_finished = false
	player.sprite.play(animation_name)
	player.sprite.flip_h = sprite_flip
#	apply_knockback()
	

#func apply_knockback() -> void:
#	var attack_dir = (player.global_position - hurtbox.hitting_area.global_position).normalized()
#	player.velocity.x = attack_dir.x * knockback_force

func exit(new_state: State = null) -> void:
	super.exit(new_state)
	total_frame_count = 0
	player.velocity.x = 0

func _on_animation_finished() -> void:
	if player.sprite.animation == animation_name:
		stun_finished = true
		
func apply_stun_time(time : int) ->void:
	##ajoute time frame de stun si c'est plus que le stun déjà restant
	total_frame_count = max(total_frame_count - frame_count, time)
	frame_count = 0
		

func process_physics(delta: float) -> State:
	super.process_physics(delta)
	if stun_finished:
		return idle_state
	frame_count +=1
	if frame_count >= total_frame_count :
		stun_finished = true
		frame_count = 0
	return null
