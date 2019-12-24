extends "./Free_Motion_State.gd"

var jump = false;

func enter():
	host.move_state = 'move_on_ground';

func handleAnimation():
	if(jump):
		host.animate(host.spr_anim,"jump", false);
	elif(host.hspd > 0 || host.hspd < 0):
		host.animate(host.spr_anim,"run", false);
	else: 
		host.animate(host.spr_anim,"idle", false);

func handleInput():
	if(get_attack_just_pressed()):
		exit(attack);
		return;
	elif(Input.is_action_just_pressed("Jump")):
		jump = true;
		air.jumped = true;
	elif(!host.on_floor() && !jump):
		exit(air);
		return;

func execute(delta):
	.execute(delta);
	#if(host.Direction != sign(host.velocity.x) && get_input_direction() != 0 ):
	#	host.hspd -= 10 * sign(host.hspd);

func exit(state):
	jump = false;
	.exit(state);


func _on_JumpTimer_timeout():
	if(host.move_state == 'move_on_ground'):
		exit(air);