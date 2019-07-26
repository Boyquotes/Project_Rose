extends "./Free_Motion_State.gd"

var climb = false;
var hstop = false;
var stickVar = 5;
var ledge_cast;
var played = false;

func enter():
	host.move_state = 'ledge_grab';
	host.grav_activated = false;
	host.hspd = 0;
	host.vspd = 0;
	pass

func handleAnimation():
	if(!played):
		host.animate(host.get_node("TopAnim"),"ledgegrab", false);
	elif(climb):
		host.animate(host.get_node("TopAnim"),"climb", false);

func handleInput():
	if(Input.is_action_pressed("up") && Input.is_action_just_pressed("jump") && ($Climbbox.get_overlapping_areas().size() == 0 && $Climbbox.get_overlapping_bodies().size() == 0)):
		
		climb = true;
	elif(Input.is_action_just_pressed("jump")):
		turn(host.Direction * -1);
		host.vspd = -host.jspd*2/5;
		host.hspd = host.mspd * host.Direction;
		$Jump_Timer.start();
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
		host.position.y -= 1;
	pass

func exit(state):
	host.grav_activated = true;
	hstop = false;
	played = false;
	stickVar = 5;
	climb = false;
	.exit(state);
	pass

func done_ledge_grab():
	played = true;

func Climb(node: NodePath):
	var sprite = host.get_node(node)
	host.global_position = $Climbbox.global_position;
	sprite.global_position = host.global_position;
	exit(ground)
	pass


func _on_Jump_Timer_timeout():
	if(host.move_state == 'ledge_grab'):
		exit(air);
