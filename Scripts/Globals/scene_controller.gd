extends Node

func change_scene_to_file(scene):
	match(get_tree().change_scene_to_file(scene)):
		OK:
			#success
			pass
		ERR_CANT_OPEN:
			printerr("Can't open " + scene)
		ERR_CANT_CREATE:
			printerr("Can't create " + scene)

