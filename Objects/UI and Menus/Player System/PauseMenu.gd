extends PanelContainer

func _ready():
	hide();

func _on_CloseMenuButton_pressed():
	hide();
	$VBoxContainer/UpgradeMenuButton/UpgradeMenu.hide();
	$VBoxContainer/ControlsMenuButton/ControlsMenu.hide();
	get_tree().paused = false;

func _on_MainMenuButton_pressed():
	pass # Replace with function body.

func _on_ExitGameButton_pressed():
	get_tree().quit();

func _on_UpgradeMenuButton_pressed():
	$VBoxContainer/UpgradeMenuButton/UpgradeMenu.popup();


func _on_ControlsMenuButton_pressed():
	$VBoxContainer/ControlsMenuButton/ControlsMenu.popup();
