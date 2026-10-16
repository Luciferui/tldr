class_name SandbagPainState
extends State

@export var animation_name: String = "pain"
@export var knockback_force: float = 300.0
@export var hurtbox: PlayerHurtbox
@export var idle_state: State

var stun_finished: bool = false
var frame_count : int
var total_frame_count : int = 0
var sandbag : Sandbag

func _ready() ->void:
	sandbag = owner as Sandbag

func enter() -> void:
	stun_finished = false
	sandbag.sprite.play(animation_name)
#	apply_knockback()
	

func apply_knockback(_attack : AttackData, _pos : Vector2, _orientation:int) -> void:
	pass
	

func exit(new_state: State = null) -> void:
	super.exit(new_state)
	total_frame_count = 0

func _on_animation_finished() -> void:
	pass
		
func apply_stun_time(time : int) ->void:
	##ajoute time frame de stun si c'est plus que le stun déjà restant
	total_frame_count = max(total_frame_count - frame_count, time)
	frame_count = 0
		

func process_physics(delta: float) -> State:
	super.process_physics(delta)
	if not sandbag.is_on_floor():
		sandbag.velocity += sandbag.get_gravity() * delta	
	if stun_finished:
		return idle_state
	frame_count +=1
	if frame_count >= total_frame_count :
		stun_finished = true
		frame_count = 0
	return null
