class_name SandbagIdleState
extends State

@export var animation_name: String = "idle"

var attackActions: Array[StringName]
var sandbag : Sandbag

func _ready() -> void:
	sandbag = owner as Sandbag

func enter() -> void:
	super.enter()
	sandbag.sprite.play(animation_name)
	
#func exit(state : State = null) -> void:
#	print("exit idle")

func process_input(_event: InputEvent) -> State:
	return null

func process_physics(delta: float) -> State:
	if not sandbag.is_on_floor():
		sandbag.velocity += sandbag.get_gravity() * delta	
	return null
