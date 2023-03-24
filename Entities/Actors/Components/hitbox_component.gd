extends Area2D

@export var bonus_iframes := 0.0

func toggle_enabled():
	monitoring = true

func toggle_disabled():
	monitoring = false

func activate_iframe(iframe_time : float):
	$Timer.start(iframe_time + bonus_iframes)
	monitoring = false

func deactivate_iframe():
	monitoring = true
