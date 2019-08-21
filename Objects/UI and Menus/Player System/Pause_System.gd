extends Control


func _process(delta):
	if(Input.is_action_just_pressed("pause") && !get_tree().paused):
		get_tree().paused = true;
		$PopupMenu.popup();
		$PopupMenu.popup_centered_ratio(.5);
	elif((Input.is_action_just_pressed("ui_cancel") || Input.is_action_just_pressed("pause")) && get_tree().paused):
		get_tree().paused = false;
		$PopupMenu.hide();

#TODO:
#Create pause menu on pause action
#Pause menu should:
	#Allow player to edit inputs
		#InputMap singleton will be needed for this
	#Allow player to exit the game to menu
	#Allow player to quit game
	#Allow player to adjust game volume
	#Temporarily allow player to set different upgrades
