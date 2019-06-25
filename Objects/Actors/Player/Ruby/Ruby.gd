extends "res://Objects/Actors/Actor.gd"

###states###
#TODO: hurt_state
onready var move_states = {
	'move_on_ground' : $Movement_States/Move_On_Ground,
	'move_in_air' : $Movement_States/Move_In_Air,
	'ledge_grab' : $Movement_States/Ledge_Grab,
	'boost' : $Movement_States/Boost,
	'lock_down' : $Movement_States/Lock_Down
}
var move_state = 'move_on_ground';
onready var style_states = {
	'melee' : $Style_States/Melee,
	'ranged' : $Style_States/Ranged
}
var style_state = 'melee';


###hitbox detection###
var targettableHitboxes = [];
var itemTrace = [];

###camera control###
onready var cam = get_node("Camera2D");

###Player Vars###
var bullets = 0;
var rad = 0.0;
var deg = 0.0;
var grav_activated = true;
var input_type = "controller";

var boosting = false;
var locking = false;

enum InputType {GAMEPAD, KEYMOUSE};
var ActiveInput = InputType.GAMEPAD;

func _ready():
	reset_hitbox();
	#$Stamina_Timer.wait_time = .1
	max_hp = 1;
	damage = 1;
	mspd = 200;
	jspd = 400;
	hp = max_hp;
	tag = "player";
	gravity = 1800;
	pass;

func reset_defaults():
	mspd = 200;
	jspd = 400;
	gravity = 1800;
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
	#print(Engine.get_frames_per_second());
	hitboxLoop();
	pass;

func phys_execute(delta):
	#state machine
	#states[state].handleAnimation();
	move_states[move_state].handleInput();
	move_states[move_state].handleAnimation();
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
		var hit = nextRay(self,item,10,space_state);
		if(hit):
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

func mouse_r():
	return (deg > -60 && deg < 60);

func mouse_u():
	return (deg > -150 && deg < -30);

func mouse_l():
	return (deg > 120 || deg < -120);

func mouse_d():
	return (deg < 150 && deg > 30);

func reset_hitbox():
	#$CollisionShape2D.scale.y = 1
	#$CollisionShape2D.position.y = 0;
	pass;

func add_velocity(vec: Vector2 = Vector2(0,0)):
	hspd += vec.x * Direction;
	vspd += vec.y;
	pass;

func subtract_velocity(vec: Vector2 = Vector2(0,0)):
	hspd -= vec.x * Direction;
	vspd -= vec.y;
	pass;