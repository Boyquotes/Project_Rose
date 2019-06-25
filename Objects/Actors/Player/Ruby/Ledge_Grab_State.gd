extends "./State.gd"

var climb = .5
var hstop = false;

func enter():
	host.move_state = 'ledge_grab';
	host.grav_activated = false;
	host.hspd = 0;
	host.vspd = 0;
	pass

func handleAnimation():
	host.animate(host.get_node("TopAnim"),"ledgegrab", false);
	host.animate(host.get_node("BotAnim"),"ledgegrab", false);
	pass;

func handleInput():
	if(Input.is_action_just_pressed("up") && $Climbbox.get_overlapping_bodies().size() == 0):
		$Climb_Timer.wait_time = climb;
		$Climb_Timer.start();
	elif(Input.is_action_just_pressed("jump")):
		host.vspd = -host.jspd*3/5;
		exit(host.get_node("Movement_States").get_node("Move_In_Air"));
	pass

func execute(delta):
	#Snap to ledge side
	if(host.is_on_wall()):
		hstop = true;
	if(!host.test_move(host.transform, Vector2(1 * host.Direction,0)) && !hstop):
		host.position.x += 1 * host.Direction;
	else:
		hstop = true;
	#Snap to ledge height
	if(host.get_node("ledge_cast").is_colliding()):
		host.position.y -= 3;
	pass

func exit(state):
	host.grav_activated = true;
	hstop = false;
	.exit(state);
	pass


func _on_Climb_Timer_timeout():
	host.position.x += 10 * host.Direction;
	host.position.y -= 20;
	exit(host.get_node("Movement_States").get_node("Move_On_Ground"))
	pass
