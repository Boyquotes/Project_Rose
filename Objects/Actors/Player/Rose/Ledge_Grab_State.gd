extends "./State.gd"

var climb = .5

func enter():
	host.state = 'ledge_grab';
	host.hspd = 0;
	host.vspd = 0;
	pass

func handleAnimation():
	pass;

func handleInput(event):
	if(event.is_action_pressed("up")):
		$Climb_Timer.wait_time = climb;
		$Climb_Timer.start();
	elif(event.is_action_just_pressed("jump")):
		host.vspd = -host.jspd/2;
		exit('move_in_air');
	pass

func execute(delta):
	#Snap to ledge side
	if(!host.test_move(host.transform, Vector2(1 * host.Direction,0))):
		host.position.x += 10 * host.Direction;
	#Snap to ledge height
	if(host.get_node("ledge_cast").is_colliding()):
		host.position.y -= 3;
	pass

func exit(state):
	.exit(state);
	pass


func _on_Climb_Timer_timeout():
	host.position.x += 10 * host.Direction;
	host.position.y -= 20;
	exit('move_on_ground');
	pass
