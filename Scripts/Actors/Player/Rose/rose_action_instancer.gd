class_name RoseActionInstancer
extends ActionInstancer

func dodge():
	var action = instance_dodge()
	action.start()

func instance_dodge():
	action_queue.push_back(preload("res://Game Objects/Actions/Player Actions/Rose/DodgeAction.tscn").instance())
	var action = action_queue.back()
	initialize_action(action, action_target)
	initialize_particles(action)
	return action