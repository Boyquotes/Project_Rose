extends "res://Objects/Actors/Actor.gd"

signal consume_resource;

###states###
#TODO: hurt_state
onready var states = {
	'move_on_ground' : $States/Move_On_Ground,
	'move_in_air' : $States/Move_In_Air,
	'attack' : $States/Attack,
	'ledge_grab' : $States/Ledge_Grab,
	'vault' : $States/Vault
}
var state = 'move_on_ground';

###hitbox detection###
var targettableHitboxes = [];
var itemTrace = [];

###camera control###
onready var cam = get_node("Camera2D");

###Player Vars###
var magic_bool = false;
var stamina_bool = true;
var mana = 100;
var max_mana = 100;
var stamina = 100;
var max_stamina = 100;
var resource = 0;
var rad = 0.0;
var deg = 0.0;

### vars to send elsewhere
var mouse_enabled = true;

func _ready():
	reset_hitbox();
	$Camera2D.current = true;
	$Stamina_Timer.wait_time = .1
	max_hp = 1;
	damage = 1;
	mspd = 200;
	jspd = 400;
	hp = max_hp;
	tag = "player";
	gravity = 1800;
	pass;

func execute(delta):
	rad = atan2(get_global_mouse_position().y - global_position.y , get_global_mouse_position().x - global_position.x)
	deg = rad2deg(rad);
	
	hitboxLoop();
	manage_resources();
	
	pass;

func phys_execute(delta):
	#print(state);
	#print(vspd);
	#state machine
	states[state].handleAnimation();
	states[state].handleInput(Input);
	states[state].execute(delta);
	#count time in air
	air_time += delta;
	
	#move across surfaces
	velocity.y = vspd;
	velocity.x = hspd;
	velocity = move_and_slide(velocity, floor_normal);
	print(velocity.y);
	#no gravity acceleration when on floor
	if(is_on_floor()):
		air_time = 0;
		velocity.y = 0
		vspd = 0;
		states['attack'].air_counter = 1;
	
	if(grav_activated()):
		vspd += gravity * delta;
	
	#cap gravity
	if(vspd > g_max && !states['attack'].dashing) :
		vspd = g_max;
	
	if(is_on_ceiling()):
		vspd = 0;
	pass;

func grav_activated():
	return (!states['attack'].dashing && 
			!states['attack'].floating && 
			state != 'ledge_grab' && 
			!states['vault'].vaulting &&
			!states['vault'].vaulted &&
			!states['move_in_air'].jumping );

func _on_DetectHitboxArea_area_entered(area):
	if(!targettableHitboxes.has(area)):
		targettableHitboxes.push_back(area);
	pass;
func _on_DetectHitboxArea_area_exited(area):
	if(targettableHitboxes.has(area)):
		targettableHitboxes.erase(area);
	pass;

func hitboxLoop():
	var space_state = get_world_2d().direct_space_state;
	for item in targettableHitboxes:
		var slash = nextRay(self,item,10,space_state);
		var bash = nextRay(self,item,11,space_state);
		var pierce = nextRay(self,item,12,space_state);
		if(slash || bash || pierce):
			item.hittable = true;
		else:
			item.hittable = false;
	pass;

func nextRay(origin,dest,col_layer,spc):
	if(!itemTrace.has(origin)):
		itemTrace.push_back(origin);
	var result = spc.intersect_ray(origin.global_position, dest.global_position, itemTrace, $RayCastCollision.collision_mask);
	if(result.empty()):
		itemTrace.clear();
		return true;
	
	elif(result.collider.get_collision_layer_bit(col_layer)):
		if(result.collider != dest):
			return nextRay(result.collider,dest,col_layer,spc);
		else:
			itemTrace.clear();
			return true;
	
	else:
		itemTrace.clear();
		return false;

func manage_resources():
	if(Input.is_action_just_pressed("switchY")):
		if(stamina_bool):
			stamina_bool = false;
			magic_bool = true;
		elif(magic_bool):
			stamina_bool = true;
			magic_bool = false;
	if(stamina_bool):
		resource = stamina;
	elif(magic_bool):
		resource = mana;
	if(stamina > max_stamina):
		stamina = max_stamina;
	if(mana > max_mana):
		mana = max_mana;
	pass;

func _on_Rose_consume_resource(cost):
	if(stamina_bool):
		stamina -= cost;
	elif(magic_bool):
		mana -= cost;
	pass;

func _on_Stamina_Timer_timeout():
	if(states['attack'].attack_spawned):
		$Stamina_Timer.start();
	elif(stamina < 100):
		stamina += 1;
	#print(resource);
	pass;

func mouse_r():
	return (deg > -60 && deg < 60) && mouse_enabled;

func mouse_u():
	return (deg > -150 && deg < -30) && mouse_enabled;

func mouse_l():
	return (deg > 120 || deg < -120) && mouse_enabled;

func mouse_d():
	return (deg < 150 && deg > 30) && mouse_enabled;

func reset_hitbox():
	$CollisionShape2D.scale.y = 1
	$CollisionShape2D.position.y = 0;
	$Hitbox/CollisionShape2D2.scale.y = 1;
	$Hitbox/CollisionShape2D2.position.y = 0;
	pass;