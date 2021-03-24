extends Node

func change_scene(scene):
	match(get_tree().change_scene(scene)):
		OK:
			#success
			pass
		ERR_CANT_OPEN:
			printerr("Can't open " + scene)
		ERR_CANT_CREATE:
			printerr("Can't create " + scene)
