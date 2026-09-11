class_name PlayerPunchState
extends PlayerAttackState

func enter() -> void :
	super.enter()
	totalFrameCount = 120
	animation_name = "fall"
