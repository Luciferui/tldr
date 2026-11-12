## État d'attente / repos du mannequin d'entraînement (Sandbag).
class_name SandbagIdleState
extends State

@export var animation_name: String = "idle"

var attackActions: Array[StringName]
var sandbag : Sandbag

# Récupère la référence vers le mannequin propriétaire
func _ready() -> void:
	sandbag = owner as Sandbag

# Lance l'animation d'attente à l'entrée dans l'état
func enter() -> void:
	super.enter()
	sandbag.sprite.play(animation_name)

func process_input(_event: InputEvent) -> State:
	return null

# Applique la gravité lorsque le mannequin n'est pas au sol
func process_physics(delta: float) -> State:
	if not sandbag.is_on_floor():
		sandbag.velocity += sandbag.get_gravity() * delta	
	return null
