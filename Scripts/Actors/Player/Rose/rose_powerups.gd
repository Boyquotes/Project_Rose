extends Node2D

@export var debug := false

@export var powerups := {
	GlobalEnums.Powerups.BASE_STYLE : true,
	GlobalEnums.Powerups.VORTEX_STYLE : false,
	GlobalEnums.Powerups.METEOR_STYLE : false
}

func toggle_powerup(powerup, toggle=true):
	powerups[powerup] = toggle
