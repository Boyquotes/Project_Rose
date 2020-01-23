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

func search_nearest_target(x,y):
	var shortest = 1000.0;
	var shortest_targ = next;
	for hitbox in host.targettable_hitboxes:
		if(x == 1):
			if(prev.global_position.x < hitbox.global_position.x):
				var dis = prev.global_position.distance_to(hitbox.global_position);
				if(shortest < dis):
					shortest = dis;
					shortest_targ = hitbox;
		if(x == -1):
			if(prev.global_position.x > hitbox.global_position.x):
				var dis = prev.global_position.distance_to(hitbox.global_position);
				if(shortest < dis):
					shortest = dis;
					shortest_targ = hitbox;
		if(y == 1):
			if(prev.global_position.y < hitbox.global_position.y):
				var dis = prev.global_position.distance_to(hitbox.global_position);
				if(shortest < dis):
					shortest = dis;
					shortest_targ = hitbox;
		if(y == -1):
			if(prev.global_position.y > hitbox.global_position.y):
				var dis = prev.global_position.distance_to(hitbox.global_position);
				if(shortest < dis):
					shortest = dis;
					shortest_targ = hitbox;
	targ.global_position = shortest_targ.globa_position;
	return shortest_targ;

func pausedHandleInput():
	if(Input.is_action_pressed("Move_Left") || Input.is_action_pressed("Aim_Left")):
		next = search_nearest_target(-1,0);
	if(Input.is_action_pressed("Move_Right") || Input.is_action_pressed("Aim_Right")):
		next = search_nearest_target(1,0);
	if(Input.is_action_pressed("Move_Up") || Input.is_action_pressed("Aim_Up")):
		next = search_nearest_target(-1,0);
	if(Input.is_action_pressed("Move_Down") || Input.is_action_pressed("Aim_Down")):
		next = search_nearest_target(1,0);
	if(Input.is_action_just_pressed("Jump")):
		if(next == null):
			HomingAttack();
		if(next != null):
			var space_state = get_world_2d().direct_space_state;
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
