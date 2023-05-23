extends Sprite2D

@export var fade_mod := 0.1
var fade := false

func _process(delta):
	if fade and modulate.a > 0:
		modulate.a -= fade_mod
	if modulate.a < 0:
		modulate.a = 0
	if not fade and modulate.a < 1:
		modulate.a += fade_mod
	if modulate.a > 1:
		modulate.a = 1

func _on_fade_area_entered(area):
	fade = true


func _on_defade_area_entered(area):
	fade = false
