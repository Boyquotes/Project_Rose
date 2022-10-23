class_name RoseActionInstancer
extends ActionInstancer

func dodge():
	var action = instance_dodge()
	action.start()

func instance_dodge():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/DodgeAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action)
	return action

func instance_primary_base1():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/PrimaryBase1Action.tscn").instantiate()
	var action = last_queued_action
	action = initialize_action(action, false, true)
	action = initialize_hitboxes(action)
	action.start()
	return action

func instance_primary_base2():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/PrimaryBase2Action.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, true)
	initialize_hitboxes(action)
	action.start()
	return action

func instance_primary_base_up():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/PrimaryBaseUpAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, true)
	initialize_hitboxes(action)
	action.start()
	return action

func instance_primary_base_up_air():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/PrimaryBaseUpAirAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, true)
	initialize_hitboxes(action)
	action.start()
	return action

func instance_primary_base_air():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/PrimaryBaseAirAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, true)
	initialize_hitboxes(action)
	action.start()
	return action

func instance_primary_base_down_air():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/PrimaryBaseDownAirAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, true)
	initialize_hitboxes(action)
	action.start()
	return action

func instance_secondary_base():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/SecondaryBaseAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, true)
	initialize_hitboxes(action)
	action.start()
	return action

func instance_secondary_base_crouch():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/SecondaryBaseCrouchAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, true)
	initialize_hitboxes(action)
	action.start()
	return action

func instance_item_needle():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/ItemNeedleAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, false)
	initialize_hitboxes(action)
	action.start()
	return action

func instance_item_needle_horup():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/ItemNeedleHorUpAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, false)
	initialize_hitboxes(action)
	action.start()
	return action

func instance_item_needle_hordown():
	last_queued_action = preload("res://Game Objects/Actions/Player Actions/Rose/ItemNeedleHorDownAction.tscn").instantiate()
	var action = last_queued_action
	initialize_action(action, false, false)
	initialize_hitboxes(action)
	action.start()
	return action
