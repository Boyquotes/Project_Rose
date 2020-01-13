extends AnimationPlayer

var hold = false;

func _process(delta):
	if(get_parent().can_channel_and_focus):
		if(Input.is_action_just_pressed("Channel")):
			play("Activate_Channel");
		if(Input.is_action_pressed("Channel") && hold):
			play("Hold_Channel");
		elif(Input.is_action_just_released("Channel")):
			play("Deactivate_Channel");
			hold = false;
	else:
		play("Inactive");

func _on_ChannelAnim_animation_finished(anim_name):
	if(anim_name == "Activate_Channel"):
		hold = true;
	if(!Input.is_action_pressed("Channel")):
		play("Inactive");
