class_name TutorialManager
extends Control
var phases : Array[RichTextLabel] = [null,null,null,null,null]
var currentPhase : int = 0
@export var player : Player
@export var sandbag : Sandbag


func _ready() ->void:
	var i : int = 0
	for child in get_children():
		phases[i] = child as TutorialText
		child.set_deferred("visible",false)
		i+=1
	currentPhase = 0
	phases[currentPhase].set_deferred("visible",true)

func reset() ->void:
	for phase in phases:
		phase.reset()
	currentPhase = 0
	
func process_input(event : InputEvent) -> void:
	print("here")
	var activate : int = -1
	match currentPhase :
		0 :
			if event.is_action_pressed("p1_jump"):
				activate = 0
			if event.is_action_pressed("p1_left"):
				activate = 1
			if event.is_action_pressed("p1_right"):
				activate = 2
		1:
			if event.is_action_pressed("p1_light"):
				if player.is_on_floor():
					activate = 0
				else:
					activate = 1
			if event.is_action_pressed("p1_heavy"):
				if player.is_on_floor():
					activate = 2
				else:
					activate = 3
		2:
			if event.is_action_pressed("p1_dodge"):
				activate = 0
		3:
			if event.is_action_pressed("p1_endcombo"):
				activate = 0
			if event.is_action_pressed("p1_spell"):
				activate = 1
	var next : bool = phases[currentPhase].activate_checkbox(activate)
	if next :
		tutorial_next()

func tutorial_next()->void:
	if currentPhase<4:
		phases[currentPhase].set_deferred("visible",false)
		phases[currentPhase+1].set_deferred("visible",true)
		currentPhase +=1

	
