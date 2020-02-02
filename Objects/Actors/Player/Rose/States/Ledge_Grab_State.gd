extends "./Free_Motion_State.gd"

var climb = false;
var hstop = false;
var dir = 1;
var stickVar = 5;
var ledge_cast;
var ledge_box;
var played = false;
var going_up = false;
var going_down = false;
var jumped = false;

func enter():
	host.move_state = 'ledge_grab';
	host.grav_activated = false;
	host.hspd = 0;
	host.vspd = 0;
	if(!ledge_cast.is_colliding() && ledge_box.get_overlapping_bodies().size() == 0):
		going_down = true;
	elif(ledge_cast.is_colliding() && ledge_box.get_overlapping_bodies().size() == 0):
		going_up = true;
	update_look_direction_and_scale(dir);
	pass

func handleAnimation():
	if(!played):
		host.animate(host.spr_anim,"ledgegrab", false);
	elif(climb):
		host.animate(host.spr_anim,"climb", false);

func handleInput():
	dir = get_input_direction();
	if(!jumped && !climb && Input.is_action_pressed("Move_Down")):
		host.position.y += 1;
		exit(air);
	elif(!jumped && !climb && ((Input.is_action_pressed("Move_Up") && dir != host.Direction * -1) || dir == host.Direction) && 
	($Climbbox.get_overlapping_areas().size() == 0 && $Climbbox.get_overlapping_bodies().size() == 0)):
		climb = true;
	elif(!jumped && !climb && Input.is_action_just_pressed("Jump")):
		jumped = true;
		turn(host.Direction * -1);
		host.vspd = -host.true_jspd*2/5;
		host.hspd = host.true_mspd * host.Direction;
		$Jump_Timer.start();

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
	if(going_up && ledge_cast.is_colliding() && ledge_box.get_overlapping_bodies().size() == 0):
		host.position.y -= 1;
	else:
		going_up = false;
	if(going_down && !ledge_cast.is_colliding() && ledge_box.get_overlapping_bodies().size() == 0):
		host.position.y += 1;
	else:
		going_down = false;
		going_up = true;
	pass

func exit(state):
	host.get_node("PhysicsCollider").call_deferred("set_disabled", false);
	host.grav_activated = true;
	hstop = false;
	played = false;
	stickVar = 5;
	climb = false;
	jumped = false; 
	going_up = false;
	going_down = false;
	.exit(state);
	pass

func done_ledge_grab():
	played = true;

func Climb():
	exit(ground);


func _on_Jump_Timer_timeout():
	if(host.move_state == 'ledge_grab'):
		exit(air);
