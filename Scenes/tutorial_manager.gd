class_name TutorialManager
extends Control
var phases : Array[RichTextLabel]
var currentPhase : int = 0
var ddr : RandomDDR
var holded : bool
#nécessaire dû au fait que player.hold=-1 se déclenche avant que le check ici, 
#et on ne peut pas changer l'ordre

@onready var next_text:RichTextLabel = $Next_is_enter
@export var player : Player
@export var sandbag : Sandbag


func _ready() ->void:
	holded=false
	ddr = player.ddr
	phases.resize(get_child_count())
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
	var activate : int = -1
	if event.is_action_released("tutorial_next"):
		tutorial_next()
	else:
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
				phases[currentPhase].counter.set_text(str(ddr.total_input))
				#print(player.get_hold())
				if event.is_action_pressed("p1_spell") and ddr.total_input>3:
					activate = 0
					holded = true
				elif event.is_action_pressed("p1_spell") and holded:
					activate = 1
					holded = false
			4:
				if event.is_action_pressed("p1_spell") and ddr.total_input>3:
					holded = true
				elif event.is_action_pressed("p1_spell") and holded:
					activate = 0
		var next : bool = phases[currentPhase].activate_checkbox(activate)
		if next :
			next_text.set_deferred("visible",true)

func tutorial_next()->void:
	if currentPhase<phases.size()-2:
		next_text.set_deferred("visible",false)
		phases[currentPhase].set_deferred("visible",false)
		phases[currentPhase+1].set_deferred("visible",true)
		currentPhase +=1
