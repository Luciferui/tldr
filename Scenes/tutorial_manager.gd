## Gestionnaire de progression du tutoriel : découpe l'apprentissage en phases distinctes
## (déplacements, attaques légères/lourdes, esquive, DDR, sorts) et valide les objectifs.
class_name TutorialManager
extends Control
var phases : Array[RichTextLabel]
var currentPhase : int = 0
var ddr : RandomDDR
var holded : bool
# Nécessaire car player.hold = -1 s'exécute avant la vérification ici

@onready var next_text:RichTextLabel = $Next_is_enter
@export var player : Player
@export var sandbag : Sandbag

# Initialise la liste des phases de texte et active uniquement la première
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

# Réinitialise toutes les phases du tutoriel au début
func reset() ->void:
	for phase in phases:
		phase.reset()
	currentPhase = 0

# Analyse les touches pressées selon la phase active pour valider les objectifs correspondants
func process_input(event : InputEvent) -> void:
	var activate : int = -1
	if event.is_action_released("tutorial_next"):
		tutorial_next()
	else:
		match currentPhase :
			0 : # Phase 0 : Déplacements (saut, gauche, droite)
				if event.is_action_pressed("p1_jump"):
					activate = 0
				if event.is_action_pressed("p1_left"):
					activate = 1
				if event.is_action_pressed("p1_right"):
					activate = 2
			1: # Phase 1 : Attaques au sol et en l'air (légère et lourde)
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
			2: # Phase 2 : Esquive
				if event.is_action_pressed("p1_dodge"):
					activate = 0
			3: # Phase 3 : Rythme DDR et préparation de sort
				phases[currentPhase].counter.set_text(str(ddr.total_input))
				#print(player.get_hold())
				if event.is_action_pressed("p1_spell") and ddr.total_input>3:
					activate = 0
					holded = true
				elif event.is_action_pressed("p1_spell") and holded:
					activate = 1
					holded = false
			4: # Phase 4 : Menu pause / contrôles
				if event.is_action_pressed("Esc"):
					activate = 0
			5: # Phase 5 : Sort final
				if event.is_action_pressed("p1_spell") and ddr.total_input>3:
					holded = true
				elif event.is_action_pressed("p1_spell") and holded:
					activate = 0
		var next : bool = phases[currentPhase].activate_checkbox(activate)
		if next :
			next_text.set_deferred("visible",true)

# Passe à l'étape suivante du tutoriel
func tutorial_next()->void:
	if currentPhase<phases.size()-2:
		next_text.set_deferred("visible",false)
		phases[currentPhase].set_deferred("visible",false)
		phases[currentPhase+1].set_deferred("visible",true)
		currentPhase +=1
