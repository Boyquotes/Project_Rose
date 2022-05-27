extends Node2D

export(bool) var debug := false

export(Dictionary) var powerups = {
	GlobalEnums.Powerups.BASE_STYLE : true,
	GlobalEnums.Powerups.VORTEX_STYLE : false,
	GlobalEnums.Powerups.METEOR_STYLE : false,
	GlobalEnums.Powerups.VOLT_STYLE : false,
	GlobalEnums.Powerups.FOCUS : false,
	GlobalEnums.Powerups.CHANNEL : false
}

func toggle_powerup(powerup, toggle=true):
	powerups[powerup] = toggle
