extends KinematicBody2D

###actor_data###
var max_hp;
#warning-ignore-
var damage;
var mspd;
var jspd;
var tag;

var hp;

###physics vars###
var air_time = 0;
var hspd = 0;
var vspd = 0;
var Direction = 1;
var gravity = 10;
var g_max = 250;
var velocity = Vector2(0,0);
var floor_normal = Vector2(0,-1);
var grav_activated = true;
var fric_activated = true;

func _ready():
	hp = max_hp;
	### default movement controller vars ###
	#1 = right, -1 = left
	Direction = 1;
	velocity = Vector2(0,0);
	floor_normal = Vector2(0,-1);
	pass;

func _process(delta):
	execute(delta);
	pass;

func _physics_process(delta):
	phys_execute(delta);
	pass;

func execute(delta):
	pass;

func phys_execute(delta):
	pass;

var first = false;
func animate(animator, anim, cont = true):
	animator.stop(cont);
	animator.play(anim);
	pass;

func Kill():
	#TODO: death anims and effects
	queue_free();

func on_floor():
	return test_move(transform, Vector2(0,1));

func deactivate_grav():
	grav_activated = false;
	vspd = 0;
	velocity.y = 0;

func deactivate_grav_dont_stop():
	grav_activated = false;

func deactivate_fric():
	fric_activated = false;
	hspd = 0;
	velocity.x = 0;

func activate_grav():
	grav_activated = true;

func activate_fric():
	fric_activated = true;