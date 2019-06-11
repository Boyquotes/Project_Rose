extends KinematicBody2D

#warnings-disable: 

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
var gravity = 1200;
var g_max = 300;
var velocity = Vector2(0,0);
var floor_normal = Vector2(0,-1);

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

func animate(anim, cont = true):
	$animator.stop(cont);
	$animator.play(anim);
	pass;

func Kill():
	#TODO: death anims and effects
	queue_free();

func on_floor():
	return test_move(transform, Vector2(0,5));