extends "res://Objects/Actors/Actor.gd"

signal consume_resource;

###states###
#TODO: hurt_state
###states###
#TODO: hurt_state
onready var move_states = {
	'move_on_ground' : $Movement_States/Move_On_Ground,
	'move_in_air' : $Movement_States/Move_In_Air,
	'ledge_grab' : $Movement_States/Ledge_Grab
}
var move_state = 'move_on_ground';

onready var style_states = {
	'wind_dance' : $Style_States/Wind_Dance,
	'closed_fan' : $Style_States/Closed_Fan
}
var style_state = 'wind_dance';

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
var grav_activated = true;

enum InputType {GAMEPAD, KEYMOUSE};
var ActiveInput = InputType.GAMEPAD;


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
	move_states[move_state].enter();
	style_states[style_state].enter();
	pass;


func _input(event):
	if(event.get_class() == "InputEventMouseButton" || event.get_class() == "InputEventKey" || Input.get_connected_joypads().size() == 0):
		ActiveInput = InputType.KEYMOUSE;
	elif(event.get_class() == "InputEventJoypadMotion" || event.get_class() == "InputEventJoypadButton"):
		ActiveInput = InputType.GAMEPAD;


func execute(delta):
	if(ActiveInput == InputType.KEYMOUSE):
		rad = atan2(get_global_mouse_position().y - global_position.y , get_global_mouse_position().x - global_position.x);
	elif(ActiveInput == InputType.GAMEPAD):
		rad = atan2(Input.get_joy_axis(0, JOY_ANALOG_LY), Input.get_joy_axis(0, JOY_ANALOG_LX));
	deg = rad2deg(rad);
	
	hitboxLoop();
	manage_resources();

func phys_execute(delta):
	#print(state);
	#print(vspd);
	#state machine
	move_states[move_state].handleAnimation();
	move_states[move_state].handleInput();
	move_states[move_state].execute(delta);
	style_states[style_state].handleInput();
	style_states[style_state].handleAnimation();
	#count time in air
	air_time += delta;
	
	#move across surfaces
	velocity.y = vspd;
	velocity.x = hspd;
	velocity = move_and_slide(velocity, floor_normal);
	#no gravity acceleration when on floor
	if(on_floor()):
		air_time = 0;
		velocity.y = 0
		vspd = 0;
	
	if(is_on_ceiling()):
		vspd = 0;
	
	if(grav_activated):
		vspd += gravity * delta;
	
	#cap gravity
	if(vspd > g_max && grav_activated) :
		vspd = g_max;
	pass;

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
#	if($Attack_Controller.attack_spawned):
#		$Stamina_Timer.start();
#	elif(stamina < 100):
#		stamina += 1;
	#print(resource);
	pass;

func mouse_r():
	return (deg > -60 && deg < 60);

func mouse_u():
	return (deg > -150 && deg < -30);

func mouse_l():
	return (deg > 120 || deg < -120);

func mouse_d():
	return (deg < 150 && deg > 30);

func reset_hitbox():
	$CollisionShape2D.scale.y = 1
	$CollisionShape2D.position.y = 0;
	$Hitbox/CollisionShape2D2.scale.y = 1;
	$Hitbox/CollisionShape2D2.position.y = 0;
	pass;

func add_velocity(vec: Vector2 = Vector2(0,0)):
	hspd = vec.x * Direction;
	vspd = vec.y;
	pass;

func subtract_velocity(vec: Vector2 = Vector2(0,0)):
	hspd -= vec.x * Direction;
	vspd -= vec.y;
	pass;

func deactivate_grav():
	grav_activated = false;
	vspd = 0;
	velocity.y = 0;
	pass;

func activate_grav():
	grav_activated = true;
	pass;
