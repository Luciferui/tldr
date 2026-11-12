## Caméra 2D dynamique : gère le tremblement d'écran (screen shake) avec amortissement et le retour fluide au zoom initial.
class_name GameCamera
extends Camera2D

@export var zoom_recovery_factor: float = 5.0
@export var shake_recovery_factor: float = 5.0

var initial_zoom: Vector2
var initial_offset: Vector2
var current_shake: float = 0.0

# Enregistre le zoom et le décalage d'origine et s'ajoute au groupe 'camera'
func _ready() -> void:
	add_to_group("camera")
	initial_zoom = zoom
	initial_offset = offset

# Amortit le zoom vers sa valeur initiale et applique les secousses aléatoires avec décroissance
func _process(delta: float) -> void:
	zoom = zoom.lerp(initial_zoom, delta * zoom_recovery_factor)
	
	if current_shake > 0:
		offset = initial_offset + Vector2(
			randf_range(-current_shake, current_shake),
			randf_range(-current_shake, current_shake)
		)
		current_shake = lerp(current_shake, 0.0, delta * shake_recovery_factor)
	else:
		offset = initial_offset

## Ajoute une impulsion de zoom (effet d'impact)
func add_zoom(amount: float) -> void:
	zoom += Vector2(amount, amount)

## Déclenche une secousse d'écran d'une intensité donnée
func add_shake(amount: float) -> void:
	current_shake = amount
