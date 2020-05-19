extends Area2D

enum ATTACK_TYPE {SLASH, BASH, PIERCE, TRUE};
enum KNOCKBACK_TYPE {AWAY, LINEAR, DIRECTIONAL, VORTEX};

export(float) var knockback;
export(KNOCKBACK_TYPE) var knockback_type;
export(ATTACK_TYPE) var attack_type;
export(float) var direction;
export(float) var inchdir = 1;
export(int) var hit_limit = 0;
export(int) var damage;
export(bool) var mark = true;
export(float) var cost = 0;
var hits = 0;
var true_knockback = 0;
var calc_direction = true;
var item_trace = [];

func _ready():
	true_knockback = knockback;

func _physics_process(delta):
	phys_execute();

func phys_execute():
	true_knockback -= 3;
	if(true_knockback <= 0):
		true_knockback = 0;
	hitboxLoop();

var host;
var attack_controller;

#determines if a player can hit a hitbox
func hitboxLoop():
	var space_state = get_world_2d().direct_space_state;
	for item in host.targettable_hitboxes:
		item.hittable = nextRay(host,item,space_state);
#the logic to determine if a specific hitbox can be hit
func nextRay(origin,dest,spc):
	if(!item_trace.has(origin)):
		item_trace.push_back(origin);
	var result = spc.intersect_ray(origin.global_position, dest.global_position, item_trace, host.AttackCollision.collision_mask);
	#if there is nothing between this attack and the destination, the item is hittable
	if(result.empty()):
		item_trace.clear();
		return true;
	elif("attack_type" in result.collider):
		#if the attack type of an item between this attack and the destination is the same attack type
			#as this attack, the attack pierces the item.
		if(result.collider.attack_type == attack_type):
			#if the current result collider is not the destination, keep looking
			if(result.collider != dest):
				return nextRay(result.collider,dest,spc);
			#else the item is hittable
			else:
				item_trace.clear();
				return true;
		#if the attack type of an item between this attack and the destination is a different attack type
			#than this attack, the attack stops at the current result.
		else:
			#if the result collider is not the destination, the attack is cut off at the result
			if(result.collider != dest):
				item_trace.clear();
				return false;
			#else, the item is hittable
			else:
				item_trace.clear();
				return true;
	else:
		item_trace.clear();
		return false;


func _on_Area2D_area_entered(area):
	if(area.hittable):
		host.get_node("Camera2D").shake(.1, 15, 8);
		hits += 1;
		if(hits >= hit_limit && hit_limit > 0):
			get_child(0).call_deferred("disabled",true);
		if(area.attack_type == attack_type):
			host.change_focus(true);
		if(mark):
			area.host.emit_signal("marked",attack_type);
		if(attack_controller):
			attack_controller.on_hit(area);
		
