	extends Control

signal set_disabled;

var disabled = false;
var can_exit = false;
var started = false;

func _process(delta):
	if(!disabled):
		if(!started && (get_focus_owner() == null || $PauseMenu/VBoxContainer.get_children().has(get_focus_owner()))):
			started = true;
			$Timer.start();
		if(started && !(get_focus_owner() == null || $PauseMenu/VBoxContainer.get_children().has(get_focus_owner()))):
			$Timer.stop()
			started = false;
			can_exit = false;
		if(Input.is_action_just_pressed("Pause") && !get_tree().paused):
			$PauseMenu/VBoxContainer/CloseMenuButton.grab_focus()
			get_tree().paused = true;
			$PauseMenu.show();
		elif(can_exit && ((Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("Pause")) && get_tree().paused)):
			get_tree().paused = false;
			$PauseMenu.hide();
			$PauseMenu/VBoxContainer/ControlsMenuButton/ControlsMenu.hide();
			$PauseMenu/VBoxContainer/UpgradeMenuButton/UpgradeMenu.hide();
		#elif((Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("Pause")) && get_tree().paused):
		#	print(get_focus_owner());
		#	get_focus_owner().hide();
#TODO: Volume control


func _on_Pause_System_set_disabled(disabled):
	for child in $PauseMenu/VBoxContainer.get_children():
			child.disabled = disabled;
	disabled = disabled


func _on_Timer_timeout():
	can_exit = true;
