## Classe de base abstraite factorisant la logique commune à tous les états du joueur
## (direction de déplacement, orientation du sprite, conservation du sens lors des transitions, gravité).
class_name PlayerState
extends State

var player: Player
var sprite_flip: bool = false

@export var move_left_action: String = "left"
@export var move_right_action: String = "right"

# Récupère la référence vers le nœud Player parent
func _ready() -> void:
	player = owner as Player

# Conserve l'orientation horizontale du sprite lors de la transition vers le nouvel état
func exit(new_state: State = null) -> void:
	if new_state is PlayerState:
		(new_state as PlayerState).sprite_flip = sprite_flip

# Applique la gravité par défaut lorsque le joueur est dans les airs
func process_physics(delta: float) -> State:
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	return null

## Retourne la direction horizontale pressée (-1 pour la gauche, 1 pour la droite, 0 si neutre)
func get_movement_direction() -> float:
	return Input.get_axis(player.left_action, player.right_action)

## Met à jour l'orientation du sprite selon la touche directionnelle pressée
func determine_sprite_flip() -> void:
	if Input.is_action_pressed(player.left_action):
		sprite_flip = not player.sprite_faces_left
	elif Input.is_action_pressed(player.right_action):
		sprite_flip = player.sprite_faces_left
	player.sprite.flip_h = sprite_flip
