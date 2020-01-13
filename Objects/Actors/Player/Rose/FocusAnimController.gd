extends AnimationPlayer

var hold = false;

func _process(delta):
	if(get_parent().can_channel_and_focus):
		if(Input.is_action_just_pressed("Focus")):
			play("Activate_Focus");
		if(Input.is_action_pressed("Focus") && hold):
			play("Hold_Focus");
		if(Input.is_action_just_released("Focus")):
			play("Deactivate_Focus");
			hold = false;
	else:
		play("Inactive");

func _on_FocusAnim_animation_finished(anim_name):
	if(anim_name == "Activate_Focus"):
		hold = true;
	if(!Input.is_action_pressed("Focus")):
		play("Inactive");
