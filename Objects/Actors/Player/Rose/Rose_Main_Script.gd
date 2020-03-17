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
	'hurt' : $Movement_States/Hurt,
	'vortex' : $Movement_States/Vortex,
	'charge' : $Movement_States/Charge,
	'homing' : $Movement_States/Homing
	}
var move_state = 'move_on_ground';
var lock = false;
var tweened = true;
var can_channel_and_focus = true;

###hitbox detection###
var targettable_hitboxes = [];
onready var AttackCollision = $AttackCollision;
export(bool) var iframe = false;

###camera control###
onready var CamNode = get_node("Camera2D");

###Player Vars###
export(float) var max_mana = 100;
export(float) var mana_recov = 1.0;
var mana = 100.0;
var regain_mana = true;
var has_focus = true;

var g_max_temp;

var rad = 0.0;
var deg = 0.0;

enum InputType {GAMEPAD, KEYMOUSE};
var active_input = InputType.GAMEPAD;

onready var spr_anim = get_node("SpriteAnim");

#sets up some variables and initializes the state machine
func _ready():
	._ready();
	iframe = false;
	g_max_temp = g_max;
	$Camera2D.current = true;
	move_states[move_state].enter();
	$PhysicsCollider.disabled = false;
	$Hitbox/Hitbox.disabled = false;


#hotswitch between keyboard and controller input
#should be able to expand this to detect different types of controllers
func _input(event):
	if(Input.is_action_pressed("Lock")):
		lock = true;
	else:
		lock = false;
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
	
	rad = $Target.execute(delta);
	deg = rad2deg(rad);
	$Target.global_rotation_degrees = deg;


#moves the player and runs state logic
func phys_execute(delta):
	if(get_tree().paused):
		paused_phys_execute(delta);
	else:
		unpaused_phys_execute(delta);

func unpaused_phys_execute(delta):
	#state machine
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

func paused_phys_execute(delta):
	move_states[move_state].pausedHandleInput();
	move_states[move_state].pausedHandleAnimation();
	move_states[move_state].pausedExecute(delta);

#cleans up attack instancing
func cleanup():
	$Movement_States/Attack/Attack_Controller/Attack_Instancing.clear();

#trigger for detecting a hitbox entering player sight zone
func _on_DetectHitboxArea_area_entered(area):
	if(!targettable_hitboxes.has(area)):
		targettable_hitboxes.push_back(area);
#trigger for detecting a hitbox leaving player sight zone
func _on_DetectHitboxArea_area_exited(area):
	if(targettable_hitboxes.has(area)):
		targettable_hitboxes.erase(area);

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
	vspd = speed * sin(deg2rad(degrees));
#useful for having the player jump from any state
func jump():
	vspd = -true_jspd;


#useful for easily changing states without having a lot of local references
func change_move_state(var state: NodePath):
	move_states[move_state].exit(get_node(state));


#These all will probably always target the sprite - might remove the NodePath argument
#sets the rotation to a convenient faux-origin based on input direction and player direction
func set_rotation_to_origin(var node: NodePath):
	get_node(node).global_rotation_degrees = 0;

#tweens the rotation to a convenient faux-origin based on input direction and player direction
func tween_rotation_to_origin(var node: NodePath, time: float = .1):
	print(get_node(node).global_rotation_degrees)
	tweened = true;
	$Tween.stop(get_node(node));
	var tDeg
	if(Direction == 1):
		tDeg = $Movement_States/Attack/Attack_Controller.attack_degrees;
		$Tween.interpolate_property(get_node(node),"global_rotation_degrees",tDeg,0,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	else:
		tDeg = $Movement_States/Attack/Attack_Controller.attack_degrees - 180 * sign($Movement_States/Attack/Attack_Controller.attack_degrees);
		$Tween.interpolate_property(get_node(node),"global_rotation_degrees",tDeg,0,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	

	$Tween.start();
#tweens rotation of node in Nodepath to the direction of the attack
func tween_sprite_rot(var node: NodePath, time: float = .1):
	var tDeg;
	$Tween.stop(get_node(node));
	if(Direction == 1):
		tDeg = $Movement_States/Attack/Attack_Controller.attack_degrees;
		$Tween.interpolate_property(get_node(node),"global_rotation_degrees",get_node(node).global_rotation_degrees,tDeg,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	else:
		tDeg = $Movement_States/Attack/Attack_Controller.attack_degrees - 180 * sign($Movement_States/Attack/Attack_Controller.attack_degrees);
		$Tween.interpolate_property(get_node(node),"global_rotation_degrees",0,tDeg,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();
#tweens position of player to a new position from its current position. Useful for abilities with set movement.
func tween_global_position(new: Vector2, time: float = .1):
	new.x = new.x * Direction;
	new = global_position + new;
	$Tween.interpolate_property(self,"global_position",global_position,new,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Tween.start();

func tween_global_position2(new: Vector2, time: float = .1):
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
	if(mana < max_mana && regain_mana):
		mana += mana_recov;
	if(mana > max_mana):
		mana = max_mana;
	emit_signal("mana_changed",mana);
func change_focus(focus):
	has_focus = focus;
	emit_signal("focus_changed", focus);

#Death trigger
func _on_Player_System_hit_zero():
	enabled = false;
	get_tree().change_scene("res://Scenes/Test_Scene.tscn");
	#$TopAnim.play("death");


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