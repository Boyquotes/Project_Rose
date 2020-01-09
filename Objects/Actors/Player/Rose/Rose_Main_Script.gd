extends "res://Objects/Actors/Actor.gd"

signal hp_changed;
signal mana_changed;
signal focus_changed;

export(int) var damage;

###states###
onready var move_states = {
	'move_on_ground' : $Movement_States/Move_On_Ground,
	'move_in_air' : $Movement_States/Move_In_Air,
	'ledge_grab' : $Movement_States/Ledge_Grab,
	'attack' : $Movement_States/Attack,
	'tethering' : $Movement_States/Tethering,
	'hurt' : $Movement_States/Hurt
}
var move_state = 'move_on_ground';
var hold_focus = false;
var tweened = true;

###hitbox detection###
var targettable_hitboxes = [];
var item_trace = [];

###camera control###
onready var CamNode = get_node("Camera2D");

###Player Vars###
export(int) var max_mana = 100;
var mana = 100;
var mana_recov = 1;

var g_max_temp;

var rad = 0.0;
var deg = 0.0;

enum InputType {GAMEPAD, KEYMOUSE};
var active_input = InputType.GAMEPAD;

onready var spr_anim = get_node("SpriteAnim");

#sets up some variables and initializes the state machine
func _ready():
	._ready();
	g_max_temp = g_max;
	$Camera2D.current = true;
	move_states[move_state].enter();
	$PhysicsCollider.disabled = false;


#hotswitch between keyboard and controller input
#should be able to expand this to detect different types of controllers
func _input(event):
	if(Input.is_action_pressed("Hold_Focus")):
		hold_focus = true;
	else:
		hold_focus = false;
	if(event.get_class() == "InputEventMouseButton" || event.get_class() == "InputEventKey" || Input.get_connected_joypads().size() == 0):
		active_input = InputType.KEYMOUSE;
	elif(event.get_class() == "InputEventJoypadMotion" || event.get_class() == "InputEventJoypadButton"):
		active_input = InputType.GAMEPAD;


#runs every frame
#home to debug inputs
#calculates the player's input rotation for aiming abilities
#also runs player hitbox "sight" to determine if an attack can hit an enemy
func execute(delta):
	### DEBUGGING, NEED TO REMOVE ###
	if(Input.is_action_just_pressed("soft_reset")):
		global_position = Vector2(0,0);
	if(Input.is_action_just_pressed("test_hp_gain")):
		change_hp(10);
	if(Input.is_action_just_pressed("test_hp_loss")):
		change_hp(-10);
	if(Input.is_action_just_pressed("test_mana_gain")):
		change_mana(10);
	if(Input.is_action_just_pressed("test_mana_loss")):
		change_mana(-10);
	
	if(active_input == InputType.KEYMOUSE):
		rad = atan2(get_global_mouse_position().y - global_position.y , get_global_mouse_position().x - global_position.x);
	elif(active_input == InputType.GAMEPAD):
		if(abs(Input.get_joy_axis(0,JOY_ANALOG_RY))>.4 || abs(Input.get_joy_axis(0,JOY_ANALOG_RX))>.4):
			rad = atan2(Input.get_joy_axis(0, JOY_ANALOG_RY), Input.get_joy_axis(0, JOY_ANALOG_RX));
		elif(abs(Input.get_joy_axis(0,JOY_ANALOG_LY))>.4 || abs(Input.get_joy_axis(0,JOY_ANALOG_LX))>.4):
			rad = atan2(Input.get_joy_axis(0, JOY_ANALOG_LY), Input.get_joy_axis(0, JOY_ANALOG_LX));
	deg = rad2deg(rad);
	
	$Target.global_rotation_degrees = deg;
	hitboxLoop();


#moves the player and runs state logic
func phys_execute(delta):
	#state machine
	#print(move_state);
	#print($Sprites/Sprite.global_rotation_degrees);
	move_states[move_state].handleInput();
	move_states[move_state].handleAnimation();
	move_states[move_state].execute(delta);
	
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
		vspd += true_gravity;
	
	#cap gravity
	if(vspd > g_max && grav_activated) :
		vspd = g_max;


#trigger for detecting a hitbox entering player sight zone
func _on_DetectHitboxArea_area_entered(area):
	if(!targettable_hitboxes.has(area)):
		targettable_hitboxes.push_back(area);
#trigger for detecting a hitbox leaving player sight zone
func _on_DetectHitboxArea_area_exited(area):
	if(targettable_hitboxes.has(area)):
		targettable_hitboxes.erase(area);
#determines if a player can hit a hitbox
#likely needs revisiting
func hitboxLoop():
	var space_state = get_world_2d().direct_space_state;
	for item in targettable_hitboxes:
		var slash = nextRay(self,item,10,space_state);
		var bash = nextRay(self,item,11,space_state);
		var pierce = nextRay(self,item,12,space_state);
		if(slash || bash || pierce):
			item.hittable = true;
		else:
			item.hittable = false;
#the logic to determine if a specific hitbox van be hit
func nextRay(origin,dest,col_layer,spc):
	if(!item_trace.has(origin)):
		item_trace.push_back(origin);
	var result = spc.intersect_ray(origin.global_position, dest.global_position, item_trace, $RayCastCollision.collision_mask);
	if(result.empty()):
		item_trace.clear();
		return true;
	
	elif(result.collider.get_collision_layer_bit(col_layer)):
		if(result.collider != dest):
			return nextRay(result.collider,dest,col_layer,spc);
		else:
			item_trace.clear();
			return true;
	
	else:
		item_trace.clear();
		return false;

#useful for easily getting the general direction of the mouse
func mouse_r():
	if(active_input == InputType.KEYMOUSE):
		return (deg > -60 && deg < 60);
	else:
		return false;
func mouse_u():
	if(active_input == InputType.KEYMOUSE):
		return (deg > -150 && deg < -30);
	else:
		return false;
func mouse_l():
	if(active_input == InputType.KEYMOUSE):
		return (deg > 120 || deg < -120);
	else:
		return false;
func mouse_d():
	if(active_input == InputType.KEYMOUSE):
		return (deg < 150 && deg > 30);
	else:
		return false;

#activates friction to deccelerate the player
func activate_fric():
	.activate_fric();
#activates gravity to pull the player down
func activate_grav():
	.activate_grav();
#deactivates friction for abilities where gravity is inconvenient
func deativate_fric():
	.deactivate_fric();
#deactivates gravity for abilities where gravity is inconvenient
func deactivate_grav():
	.deactivate_grav();
#Temporarily change gravity for the convenience of some abilities.
func change_grav(g):
	true_gravity = g;
#Temporarily change friction for the convenience of some abilities.
func change_fric(f):
	true_friction = f;
#useful for easily adding or subtracting velocity to an ability through animation
func add_velocity(speed : float, degrees : float = $Movement_States/Attack/Attack_Controller.attack_degrees):
	hspd = speed * cos(deg2rad(degrees));
	vspd = speed * sin(deg2rad(degrees))
#useful for having the player jump from any state
func jump():
	vspd = -true_jspd;


#useful for easily changing states without having a lot of local references
func change_move_state(var state: NodePath):
	move_states[move_state].exit(get_node(state));


#These all will probably always target the sprite - might remove the NodePath argument
#sets the rotation to a convenient faux-origin based on input direction and player direction
func set_rotation_to_origin(var node: NodePath):
	var tDeg;
	if(Direction == 1):
		tDeg = 0;
	else:
		if(get_node(node).global_rotation_degrees > 0):
			if($Movement_States/Attack/Attack_Controller.attack_degrees > 0):
				tDeg = -179
			else:
				tDeg = 179;
		else:
			if($Movement_States/Attack/Attack_Controller.attack_degrees < 0):
				tDeg = 179;
			else:
				tDeg = -179;
	get_node(node).global_rotation_degrees=tDeg;
#tweens the rotation to a convenient faux-origin based on input direction and player direction
func tween_rotation_to_origin(var node: NodePath, time: float = .1):
	tweened = true;
	$Tween.stop(get_node(node));
	var tDeg;
	if(Direction == 1):
		tDeg = 0;
	else:
		if(get_node(node).global_rotation_degrees > 0):
			tDeg = 180;
		else:
			tDeg = -180;
	$Tween.interpolate_property(get_node(node),"global_rotation_degrees",get_node(node).global_rotation_degrees,tDeg,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();
#tweens rotation of node in Nodepath to the direction of the attack
func tween_sprite_rot(var node: NodePath, time: float = .1):
	var tDeg;
	if(Direction == 1):
		tDeg = $Movement_States/Attack/Attack_Controller.attack_degrees;
	else:
		tDeg = -$Movement_States/Attack/Attack_Controller.attack_degrees;
	$Tween.stop(get_node(node));
	$Tween.interpolate_property(get_node(node),"global_rotation_degrees",get_node(node).global_rotation_degrees,tDeg,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();
#tweens position of player to a new position from its current position. Useful for abilities with set movement.
func tween_global_position(new: Vector2, time: float = .1):
	new.x = new.x * Direction;
	new = global_position + new;
	$Tween.interpolate_property(self,"global_position",global_position,new,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();


#convenient for changing the player's health, whether it is a heal or damage
func change_hp(health):
	hp += health;
	if(hp > max_hp):
		hp = max_hp;
	emit_signal("hp_changed",hp);
#convenient for changing the player's mana, whether it is used or replenished
func change_mana(man):
	mana += man;
	if(mana > max_mana):
		mana = max_mana;
	emit_signal("mana_changed", mana);
#replenish mana over time
func _on_manaTimer_timeout():
	if(mana < max_mana):
		mana += mana_recov;
	if(mana > max_mana):
		mana = max_mana;
	emit_signal("mana_changed",mana);


#Death trigger
func _on_Player_System_hit_zero():
	enabled = false;
	$TopAnim.play("death");


#trigger for updating powerup flags
func _on_UpgradeMenu_update_powerup(idx,activate):
	$Powerups.powerups_idx[idx] = activate;


#animates the animator with a new animation anim
func animate(animator, anim, cont = true):
	.animate(animator, anim, cont);


#might not need anymore
func tween_rotation(node: NodePath, new: float, time: float = .1):
	$Tween.interpolate_property(get_node(node),"rotation_degrees",get_node(node).rotation_degrees,new,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();
#might not need anymore
func tween_rotation_from_specified(node: NodePath, cur: float, new: float, time: float = .1):
	$Tween.interpolate_property(get_node(node),"rotation_degrees",cur,new,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();
#might not need anymore
func tween_scale(node: NodePath, new: Vector2, time: float = .1):
	$Tween.interpolate_property(get_node(node),"scale",get_node(node).scale,new,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();
#might not need anymore
func bounce():
	var deg;
	deg = $Movement_States/Attack/Attack_Controller.attack_degrees;
	deg = deg + 180;
	add_velocity(400,deg);