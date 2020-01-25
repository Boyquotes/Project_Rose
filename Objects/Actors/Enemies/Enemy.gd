extends "res://Objects/Actors/Actor.gd"

signal marked;
signal targetted;

enum ATTACK_TYPE {SLASH, BASH, PIERCE, TRUE};
var mark = null;
onready var actionTimer = get_node("Action_Timer");
onready var player = get_tree().get_root().get_node("Test/Rose");

export(int) var stun_threshold = 10;
var stun_damage = 0;

#range which the enemy attacks
export(float) var attack_range = 50;
#range which the enemy chases
export(float) var chase_range = 150;

###background_enemy_data###
var decision;

var states;
var state;

var friction = 10;
var hit = false;
var moving = false;

### Enemy ###
func _ready():
	decision = 0;
	state = 'default';

func execute(delta):
	#assumes the enemy is stored in a Node2D
	if(actionTimer.time_left <= 0.1):
		decision = makeDecision();
	
	if(hp <= 0):
		Kill();
	pass

func phys_execute(delta):
	#state machine
	#state = 'default' by default
	states[state].handleAnimation();
	states[state].handleInput(Input);
	states[state].execute(delta);
	
	velocity.x = hspd;
	velocity.y = vspd;
	velocity = move_and_slide(velocity,floor_normal);
	#no gravity acceleration when on floor
	if(on_floor()):
		velocity.y = 0
		vspd = 0;
	
	#add gravity
	if(grav_activated):
		vspd += true_gravity;
	
	#cap gravity
	if(vspd > 900):
		vspd = 900;
	if(is_on_ceiling() && base_jspd > 0):
		vspd = 500;
	
	if(fric_activated && !moving):
		if(hspd > 0):
			hspd -= friction;
		elif(hspd < 0):
			hspd += friction;
		if((hspd <= 44 && hspd > 0) || (hspd >= 44 && hspd < 0)):
			hspd = 0;

func makeDecision():
	var dec = randi() % 100 + 1;
	return dec;

func canSeePlayer():
	var space_state = get_world_2d().direct_space_state;
	var result = space_state.intersect_ray(global_position, player.global_position, [self], collision_mask);
	if(!result.empty()):
		return false;
	elif((global_position.distance_to(player.global_position) <= chase_range)):
		return true;
	return false;

func Kill():
	enabled = false;
	$Sprites.visible = false;
	.Kill();

func _on_MarkTimer_timeout():
	mark = null;


func _on_Enemy_marked(type):
	mark = type;
	$MarkTimer.start();

func _on_Enemy_targetted():
	$marks/target.visible = !$marks/target.visible;
