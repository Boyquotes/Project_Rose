extends PopupMenu

func _ready():
	add_item("Close Menu");
	add_submenu_item("Upgrades","UpgradeMenu");
	add_submenu_item("Controls", "ControlsMenu");
	add_item("Main Menu(not implemented)");
	add_item("Exit Game");

func _on_PauseMenu_index_pressed(index):
	match index:
		0: 
			hide();
			$UpgradeMenu.hide();
			$ControlsMenu.hide();
			get_tree().paused = false;
		3:
			pass;
		4:
			get_tree().quit();
