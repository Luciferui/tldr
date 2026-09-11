extends Node

@export var inputRange : int = 5

var ddrInputList : Array[String] = ["up", "down", "right", "left", "lightatk", "heavyatk"]
var playerInputs : Array[String] = []
var randomInputList : Array[String] = []
var currentInput : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	generateRandomInputs()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed(currentInput):
		validateInput()


func generateRandomInputs():
	for a in range(inputRange):
		randomInputList.append(randomInputList[randi_range(0, ddrInputList.size()-1)])
	
func validateInput():
	
	randomInputList = randomInputList.slice(1)
	randomInputList.append(randomInputList[randi_range(0, ddrInputList.size()-1)])
	
	
