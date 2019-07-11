extends "./Move_State.gd"

var climb = .5
var hstop = false;
var stickVar = 5;
var ledge_cast;

func enter():
	host.move_state = 'ledge_grab';
	host.grav_activated = false;
	host.hspd = 0;
	host.vspd = 0;
	pass

func handleAnimation():
	host.animate(host.get_node("TopAnim"),"ledgegrab", false);
	#host.animate(host.get_node("BotAnim"),"ledgegrab", false);
	pass;

func handleInput():
	if(!host.style_states[host.style_state].busy):
		if(Input.is_action_just_pressed("up") && $Climbbox.get_overlapping_bodies().size() == 0):
			$Climb_Timer.wait_time = climb;
			$Climb_Timer.start();
		elif(Input.is_action_just_pressed("jump")):
			host.vspd = -host.jspd*3/5;
			exit(air);
	if(host.velocity != Vector2(0,0)):
		exit(air);
	pass

func execute(delta):
	#Snap to ledge side
	if(host.is_on_wall()):
		hstop = true;
	if(!host.test_move(host.transform, Vector2(1 * host.Direction,0)) && !hstop):
		host.position.x += stickVar * host.Direction;
		stickVar -= 1;
	else:
		hstop = true;
	#Snap to ledge height
	if(ledge_cast.is_colliding()):
		host.position.y -= 3;
	pass

func exit(state):
	host.grav_activated = true;
	hstop = false;
	stickVar = 5;
	$Climb_Timer.stop();
	.exit(state);
	pass


func _on_Climb_Timer_timeout():
	host.global_position = $Climbbox.global_position;
	exit(ground)
	pass
