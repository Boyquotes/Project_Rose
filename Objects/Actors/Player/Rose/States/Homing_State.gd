extends "./Free_Motion_State.gd"

export(float) var cost = 10;
var cummulative_cost = 0;
var prev = null;
var next = null;
var locked = [];
var homing = false;
var home = false;
var last;
var end = false;
var o;

onready var hitbox = get_node("HomingAttackBox/CollisionShape2D");
export(float) var timer_time;
var rot;

func _ready():
	hitbox.disabled = true;
	$HomeTimer.wait_time = timer_time;
	rot = hitbox.global_rotation

func enter():
	hitbox.disabled = false;
	host.can_channel_and_focus = false;
	host.regain_mana = false;
	host.iframe = true;
	host.move_state = 'homing';
	update_look_direction_and_scale(1);
	get_tree().paused = true;
	prev = host;
	$Target.visible = true;
	$Shock.visible = false;
	$HomingLine.visible = false;
	o = host.global_position;
	host.deactivate_grav();

func handleAnimation():
	host.animate(host.spr_anim,"Homing", false);

func search_nearest_target(x,y):
	var shortest = 1000.0;
	var shortest_targ = self;
	if(next != null):
		shortest_targ = next;
	for hitbox in host.targettable_hitboxes:
		if(x == 1):
			if($Target.global_position.x < hitbox.global_position.x):
				var dis = $Target.global_position.distance_to(hitbox.global_position);
				if(shortest > dis):
					shortest = dis;
					shortest_targ = hitbox;
		if(x == -1):
			if($Target.global_position.x > hitbox.global_position.x):
				var dis = $Target.global_position.distance_to(hitbox.global_position);
				if(shortest > dis):
					shortest = dis;
					shortest_targ = hitbox;
		if(y == 1):
			if($Target.global_position.y > hitbox.global_position.y):
				var dis = $Target.global_position.distance_to(hitbox.global_position);
				if(shortest > dis):
					shortest = dis;
					shortest_targ = hitbox;
		if(y == -1):
			if($Target.global_position.y < hitbox.global_position.y):
				var dis = $Target.global_position.distance_to(hitbox.global_position);
				if(shortest > dis):
					shortest = dis;
					shortest_targ = hitbox;
	if(shortest_targ != self):
		$Target.global_position = shortest_targ.global_position;
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
				next.host.emit_signal("targetted");
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
			next.host.emit_signal("targetted");

func wallRay(origin,dest,spc):
	var result = spc.intersect_ray(origin.global_position, dest.global_position, [], host.collision_mask);
	return result.empty();

func HomingAttack():
	get_tree().paused = false;
	host.change_mana(-cummulative_cost);
	homing = true;
	last = locked[locked.size()-1];
	$Target.global_position = host.global_position;
	$Target.visible = false;
	$HomeAnim.play("Shock");

func execute(delta):
	if(homing && home):
		home = false;
		next = locked.pop_front();
		while(next == null || !weakref(next).get_ref()):
			if(locked.empty()):
				exit_g_or_a();
				return;
			next = locked.pop_front();
		var pos = Vector2(hitbox.global_position.y - next.global_position.y,hitbox.global_position.x - next.global_position.x);
		hitbox.global_rotation = atan2(pos.x,pos.y);
		o = host.global_position;
		$HomingLine.set_point_position(0, host.global_position);
		$HomingLine.set_point_position(1, next.global_position);
		$HomeAnim.play("Home");
		host.tween_global_position2(next.global_position,timer_time);
		if(next == last):
			last = last.global_position;
			$HomeTimer.start();
			end = true;
		else:
			$HomeTimer.start();
	$HomingLine.global_position = Vector2(0,0);

func exit(state):
	host.get_node("Sprites/Sprite").visible = true;
	end = false;
	o = host.global_position;
	host.activate_grav();
	$Shock.visible = false;
	$HomingLine.visible = false;
	cummulative_cost = 0;
	prev = null;
	next = null;
	hitbox.disabled = true;
	locked.clear();
	last = null;
	host.can_channel_and_focus = true;
	host.regain_mana = true;
	host.iframe = false;
	hitbox.global_rotation = rot;
	homing = false;
	home = false;
	$Target.visible = false;
	host.set_rotation_to_origin("Sprites");
	get_tree().paused = false;
	$Target.visible = false;
	.exit(state);


func _on_HomeTimer_timeout():
	$Shock.visible = true;
	$HomeAnim.play("Shock");


func _on_HomeAnim_animation_finished(anim_name):
	if(anim_name == "Shock"):
		if(end):
			host.global_position = Vector2(last.x + (16 * sign(last.x - host.global_position.x)), last.y);
			exit_g_or_a();
		else:
			home = true;