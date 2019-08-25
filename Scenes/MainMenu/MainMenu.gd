extends VBoxContainer

func _ready():
	$StartButton.grab_focus();

func _process(delta):
	if($OptionsButton.is_hovered()):
		if(Input.is_action_just_pressed("ui_right")):
			$OptionsButton/OptionsMenu.show();
			$OptionsButton/OptionsMenu/VBoxContainer/CloseMenuButton.grab_focus();

func _on_StartButton_pressed():
	get_tree().change_scene("res://Scenes/Test_Scene.tscn");

func _on_OptionsButton_pressed():
	if($OptionsButton/OptionsMenu.visible):
		$OptionsButton/OptionsMenu.hide();
		grab_focus();
	else:
		$OptionsButton/OptionsMenu.show();
		$OptionsButton/OptionsMenu/VBoxContainer/CloseMenuButton.grab_focus();


func _on_ExitButton_pressed():
	get_tree().quit();
