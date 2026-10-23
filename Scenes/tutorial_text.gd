class_name TutorialText
extends RichTextLabel

var checkboxes : Array[Sprite2D]
@export var final = false

func _ready() -> void:
	checkboxes.resize(self.get_child_count())
	var i:int = 0
	for child in get_children():
		checkboxes[i] = child
		i+=1
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
				if not check.is_visible():
					next = false
		return next
	return false
