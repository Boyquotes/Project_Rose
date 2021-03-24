class_name GenericActionInstancer
extends ActionInstancer

func swipe():
	var action = instance_swipe()
	# add additional functionality if desired
	action.start()

func pew():
	var action = instance_swipe()
	action.start()

func bomb():
	var action = instance_bomb()
	action.start()

func potion():
	var action = instance_bomb()
	action.start()

func dash():
	var action = instance_dash()
	action.start()

func instance_swipe():
	action_queue.push_back(preload("res://Game Objects/Actions/Player Actions/Generic/Swipe.tscn").instance())
	var action = action_queue.back()
	# use the initialization functions that make sense for the action
	initialize_action(action, action_target)
	initialize_hitboxes(action)
	initialize_particles(action)
	return action

func instance_pew():
	action_queue.push_back(preload("res://Game Objects/Actions/Player Actions/Generic/Pew.tscn").instance())
	var action = action_queue.back()
	initialize_action(action)
	initialize_hitboxes(action)
	initialize_particles(action)
	return action

func instance_bomb():
	action_queue.push_back(preload("res://Game Objects/Actions/Player Actions/Generic/Bomb.tscn").instance())
	var action = action_queue.back()
	initialize_action(action)
	initialize_hitboxes(action)
	initialize_particles(action)
	initialize_sprite(action)
	return action

func instance_potion():
	action_queue.push_back(preload("res://Game Objects/Actions/Player Actions/Generic/Potion.tscn").instance())
	var action = action_queue.back()
	initialize_action(action, action_target)
	initialize_particles(action)
	initialize_sprite(action)
	return action

func instance_dash():
	action_queue.push_back(preload("res://Game Objects/Actions/Player Actions/Generic/Dash.tscn").instance())
	var action = action_queue.back()
	initialize_action(action, action_target)
	initialize_particles(action)
	initialize_sprite(action)
	return action
