extends Control

signal set_disabled

var can_unpause := true

func _process(_delta):
	if not get_tree().paused and Input.is_action_just_pressed("ui_pause"):
		$PauseMenu/VBoxContainer/CloseMenuButton.grab_focus()
		get_tree().paused = true
		$PauseMenu.show()
	elif get_tree().paused and Input.is_action_just_pressed("ui_pause") and can_unpause:
		get_tree().paused = false
		$PauseMenu.hide_all()
	#elif((Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("Pause")) && get_tree().paused):
	#	print(get_focus_owner());
	#	get_focus_owner().hide();
#TODO: Volume control
