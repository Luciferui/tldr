## Affichage textuel d'une consigne de tutoriel et gestion de ses cases à cocher associées.
class_name TutorialText
extends RichTextLabel

var checkboxes : Array[Appearing_check]
@export var final = false
@export var counter : RichTextLabel

# Récupère toutes les cases à cocher enfants et les masque initialement
func _ready() -> void:
	for child in get_children():
		if child is Appearing_check:
			checkboxes.append(child)
	if not final:
		for checkbox in checkboxes :
			checkbox.set_deferred("visible",false)

# Réinitialise la visibilité de toutes les cases à cocher
func reset() ->void:
	for checkbox in checkboxes :
		checkbox.set_deferred("visible",false)

# Valide une case à cocher par son index et vérifie si toutes les cases de la phase sont validées
func activate_checkbox(i : int) ->bool:
	if not final:
		var next : bool = false
		if (0<= i) and (i < checkboxes.size()):
			checkboxes[i].set_deferred("visible",true)
			next = true
			for check in checkboxes:
				if not check.is_visible() and check!=checkboxes[i]:
					next = false
		return next
	return false
