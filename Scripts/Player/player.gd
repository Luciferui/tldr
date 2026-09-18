class_name Player
extends CharacterBody2D
##Joueur controllable [br]

@onready var state_machine: StateMachine = $StateMachine
@onready var sprite: AnimatedSprite2D = $Sprite

@export var left_action: StringName = &"p1_left"
@export var right_action: StringName = &"p1_right"
@export var jump_action: StringName = &"p1_jump"
@export var heavy_attack_action: StringName = &"p1_heavy"
@export var light_attack_action: StringName = &"p1_light"

@export var sprite_faces_left: bool = false

func _ready() -> void:
	state_machine.init()

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)
	move_and_slide()
