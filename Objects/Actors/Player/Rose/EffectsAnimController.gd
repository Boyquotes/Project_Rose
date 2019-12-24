extends AnimationPlayer

func _process(delta):
	if(Input.is_action_just_pressed("Quick_Focus")):
		play("Activate_Soft_Focus");
	if(Input.is_action_just_released("Quick_Focus")):
		play("Deactivate_Soft_Focus");