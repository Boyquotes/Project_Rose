extends "./State.gd"

func handleInput(event):
	if(host.is_attack_triggered() && host.resource >= attack_controller.base_cost):
		attack_controller.emit_signal("attack");
		pass;
	pass;

#returns direction based on input
func get_input_direction():
	var input_direction = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"));
	return input_direction;

#sets direction and turns the player appropriately
func update_look_direction(direction):
	if(direction == 0):
		return;
	if(host.Direction != direction):
		if(host.Direction != 0):
			host.get_node("Sprite").scale.x = host.get_node("Sprite").scale.x * -1;
		host.Direction = direction;