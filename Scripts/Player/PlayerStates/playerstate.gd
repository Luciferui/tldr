class_name PlayerState
extends State
## Implemente state (abstraite) 
## Classe de factorisation des states pour 
## les classes spécifiques de playerstates

## Les animations sont gérées par le sprite et SpriteFrames uniquement

var player: Player
var sprite_flip: bool = false

@export var move_left_action: String = "left"
@export var move_right_action: String = "right"

func _ready() -> void:
	player = owner as Player 
	# Owner : premier parent étant une scène (ici le node Player)

func exit(new_state: State = null) -> void:
	if new_state is PlayerState:
		(new_state as PlayerState).sprite_flip = sprite_flip
		# mémoire du sprite flip en sortie

func process_physics(delta: float) -> State:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	return null

func get_movement_direction() -> float:
	return Input.get_axis(move_left_action, move_right_action)

func determine_sprite_flip() -> void:
	if Input.is_action_pressed(move_left_action):
		sprite_flip = true
	elif Input.is_action_pressed(move_right_action):
		sprite_flip = false
	player.sprite.flip_h = sprite_flip
