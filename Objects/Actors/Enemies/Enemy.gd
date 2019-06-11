extends "res://Objects/Actors/Actor.gd"

onready var actionTimer = get_node("Action_Timer");
onready var player = get_tree().get_root().get_children()[0].get_node("Rose");

#range which the enemy attacks
export(float) var attack_range = 50;
#range which the enemy chases
export(Vector2) var chase_range = Vector2(160,32);

###background_enemy_data###
var decision;
var wait;

onready var states;
var state;

### Enemy ###
func _ready():
	decision = 0;
	wait = 0;
	state = 'default';
	pass

func execute(delta):
	#assumes the enemy is stored in a Node2D
	if(actionTimer.time_left <= 0.1):
		decision = makeDecision();
	wait = rand_range(.5, 2);
	
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
	if(is_on_floor()):
		velocity.y = 0
		vspd = 0;
	
	#add gravity
	vspd += gravity * delta;
	
	#cap gravity
	if(vspd > 900):
		vspd = 900;
	if(is_on_ceiling()):
		vspd = 500;
	pass

func makeDecision():
	var dec = randi() % 100 + 1;
	return dec;

func canSeePlayer():
	var space_state = get_world_2d().direct_space_state;
	var result = space_state.intersect_ray(global_position, player.global_position, [self], collision_mask);
	if(!result.empty()):
		return false;
	elif((abs(player.global_position.x-global_position.x) < chase_range.x) && (abs(player.global_position.y-global_position.y) < chase_range.y)):
		return true;
	return false;
