class_name TutorialText
extends RichTextLabel

var checkboxes : Array[Appearing_check]
@export var final = false
@export var counter : RichTextLabel

func _ready() -> void:
	for child in get_children():
		if child is Appearing_check:
			checkboxes.append(child)
	if not final:
		for checkbox in checkboxes :
			checkbox.set_deferred("visible",false)

func reset() ->void:
	for checkbox in checkboxes :
		checkbox.set_deferred("visible",false)
		
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
