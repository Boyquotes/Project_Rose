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
	var shortest_targ = self;
	if(next != null):
		shortest_targ = next;
	for hitbox in host.targettable_hitboxes:
		if(x == 1):
			if(targ.global_position.x < hitbox.global_position.x):
				var dis = targ.global_position.distance_to(hitbox.global_position);
				if(shortest > dis):
					shortest = dis;
					shortest_targ = hitbox;
		if(x == -1):
			if(targ.global_position.x > hitbox.global_position.x):
				var dis = targ.global_position.distance_to(hitbox.global_position);
				if(shortest > dis):
					shortest = dis;
					shortest_targ = hitbox;
		if(y == 1):
			if(targ.global_position.y > hitbox.global_position.y):
				var dis = targ.global_position.distance_to(hitbox.global_position);
				if(shortest > dis):
					shortest = dis;
					shortest_targ = hitbox;
		if(y == -1):
			if(targ.global_position.y < hitbox.global_position.y):
				var dis = targ.global_position.distance_to(hitbox.global_position);
				if(shortest > dis):
					shortest = dis;
					shortest_targ = hitbox;
	if(shortest_targ != self):
		targ.global_position = shortest_targ.global_position;
	else:
		shortest_targ = null;
	return shortest_targ;

func pausedHandleInput():
	if(Input.is_action_just_pressed("Move_Left") || Input.is_action_just_pressed("Aim_Left")):
		next = search_nearest_target(-1,0);
	if(Input.is_action_just_pressed("Move_Right") || Input.is_action_just_pressed("Aim_Right")):
		next = search_nearest_target(1,0);
	if(Input.is_action_just_pressed("Move_Up") || Input.is_action_just_pressed("Aim_Up")):
		next = search_nearest_target(-1,0);
	if(Input.is_action_just_pressed("Move_Down") || Input.is_action_just_pressed("Aim_Down")):
		next = search_nearest_target(1,0);
	if(Input.is_action_just_pressed("Jump")):
		if(next == null || locked.has(next)):
			if(locked.empty()):
				exit_g_or_a();
			HomingAttack();
		if(next != null):
			var space_state = get_world_2d().direct_space_state;
			if(wallRay(prev,next,space_state) || next.host.mark == 2):
				locked.push_back(next);
				#mark target as getting hit
				prev = next;
				next = null;
				cummulative_cost += cost;
				if(cummulative_cost >= host.mana):
					HomingAttack();
	if(Input.is_action_just_pressed("ui_cancel")):
		if(next == null):
			exit_g_or_a();
		if(locked.has(next)):
			locked.remove(locked.find(next));
			#unmark target as getting hit

func wallRay(origin,dest,spc):
	var result = spc.intersect_ray(origin.global_position, dest.global_position, [], host.collision_mask);
	return result.empty();

func HomingAttack():
	get_tree().paused = false;
	host.change_mana(-cummulative_cost);
	for enemies in locked:
		#damage each enemy
		pass;
	var last = locked[locked.size()-1];
	host.global_position = Vector2(last.global_position.x + (16 * sign(last.global_position.x - host.global_position.x)), last.global_position.y);
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
