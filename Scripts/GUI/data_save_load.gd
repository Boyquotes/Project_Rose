extends Control

@export var saving := true

func _ready():
	# should remove this in time
	if GameData.load_savedata(GameData.save_idx):
		load_scene()
	else:
		save_scene()

func _process(_delta):
	if saving:
		save_scene()

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			GameData.save_savedata(0)
		if event.keycode == KEY_Y:
			save_scene()
		if event.keycode == KEY_H:
			GameData.load_savedata(GameData.save_idx)

func load_scene():
	var load_nodes = get_tree().get_nodes_in_group("Persist")
	var load_data = GameData.save_data[get_tree().current_scene.name]
	for node in load_nodes:
		if !node.has_method("load"):
			print("persistent node '%s' is missing a load() function, skipped" % node.name)
			continue
		
		node.call("load", load_data[node.name])

func save_scene():
	var _save_scene := {}
	var save_nodes = get_tree().get_nodes_in_group("Persist")
	for node in save_nodes:
		if !node.has_method("save"):
			print("persistent node '%s' is missing a save() function, skipped" % node.name)
			continue
		
		var node_data = node.call("save")
		_save_scene[node.name] = node_data
	GameData.save_data[get_tree().current_scene.name] = _save_scene
	GameData.save_data["current_scene"] = get_tree().current_scene.scene_file_path
	GameData.save_savedata(GameData.save_idx)
