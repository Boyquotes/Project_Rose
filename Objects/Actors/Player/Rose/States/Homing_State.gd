extends "./Free_Motion_State.gd"

export(float) var cost = 10;
var cummulative_cost = 0;
onready var targ = $Target;
var prev = null;
var next = null;
var locked = []

func enter():
	host.can_channel_and_focus = false;
	host.regain_mana = false;
	host.iframe = true;
	host.move_state = 'homing';
	update_look_direction_and_scale(1);
	get_tree().paused = true;
	prev = host;
	$Target.visible = true;

func handleAnimation():
	pass;

func pausedHandleInput():
	var space_state = get_world_2d().direct_space_state;
	var result = space_state.intersect_ray(prev.global_position, 
	Vector2(prev.global_position.x + (cos(host.get_node("Target").rad) * 200),prev.global_position.y + (sin(host.get_node("Target").rad) * 200)), 
	[], host.AttackCollision.collision_mask,false,true);
	if(result.empty()):
		pass
	elif(host.targettable_hitboxes.has(result.collider) && !locked.has(result.collider)):
		targ.global_position = result.collider.global_position;
		next = result.collider;
	else: 
		pass;
	if(Input.is_action_just_pressed("Jump")):
		if(next == null):
			HomingAttack();
		if(next != null):
			if(wallRay(prev,next,space_state) || next.host.mark == 2):
				locked.push_back(next);
				prev = next;
				next = null;
				cummulative_cost += cost;
				if(cummulative_cost >= host.mana):
					HomingAttack();

func wallRay(origin,dest,spc):
	var result = spc.intersect_ray(origin.global_position, dest.global_position, [], host.collision_mask);
	return result.empty();

func HomingAttack():
	get_tree().paused = false;
	host.change_mana(-cummulative_cost);
	exit_g_or_a();

func execute(delta):
	pass;

func exit(state):
	cummulative_cost = 0;
	prev = null;
	next = null;
	locked.clear();
	host.can_channel_and_focus = true;
	host.regain_mana = true;
	host.set_rotation_to_origin("Sprites");
	get_tree().paused = false;
	$Target.visible = false;
	.exit(state);
