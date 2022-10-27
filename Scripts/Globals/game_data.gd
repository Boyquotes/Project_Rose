extends Node

var key = "nSBmhIbQCB"

var save_idx = 0

var save_data := {
	
}

func save_savedata(idx : int):
	var filename = "user://" + "savegame" + str(idx) + ".save"
	var save_game = FileAccess.open_encrypted_with_pass(filename, FileAccess.WRITE, key)
	if save_game:
		save_game.store_line(JSON.stringify(save_data))
		return true
	else:
		printerr(FileAccess.get_open_error())
		return false

func load_savedata(idx : int):
	var filename = "user://" + "savegame" + str(idx) + ".save"
	var load_game = FileAccess.open_encrypted_with_pass(filename, FileAccess.READ, key)
	if load_game:
		save_data = JSON.parse_string(load_game.get_as_text())
		return true
	else:
		printerr(FileAccess.get_open_error())
		return false

