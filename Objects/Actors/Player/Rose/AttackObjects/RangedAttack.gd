extends KinematicBody2D
var host;
var attack_state;
onready var col = get_node("collider");
export(float) var wind = .1;
export(float) var attack = .1;
export(float) var recoil = .1;
export(float) var speedx = 200;
export(float) var speedy = 200;
export(float) var fl = .6;
export(int) var mDir = 1;
export(Vector2) var knockback = Vector2(100,100);
var pos;
var displacement = Vector2(0,0);
var attack_traversal = Vector2(0,0);
export(int) var vDirection = 1;

export(bool) var movex = true;
export(bool) var movey = true;
var Direction;
var hspd;
var vspd;
var velocity = Vector2(0,0);
var floor_normal = Vector2(0,-1);
var launched = false

func _ready():
	initialize();
	pass;

func initialize():
	$Area2D.connect("area_entered", self, "on_area_entered");
	$Area2D.connect("body_entered", self, "on_body_entered");
	$WindupTimer.wait_time = wind;
	$WindupTimer.start();
	col.disabled = true;
	visible = false;
	pos = position
	attack_traversal.x = attack_state.distance_traversable * 1.5;
	attack_traversal.y = attack_state.distance_traversable * 1.5;
	Direction = host.Direction;
	hspd = 0;
	vspd = 0;
	pass;

func _physics_process(delta):
	if(movex):
		displacex();
	if(movey):
		displacey();
	velocity.y = vspd;
	velocity.x = hspd;
	velocity = move_and_slide(velocity, floor_normal);

func displacex():
	if(position.x > pos.x):
		displacement.x += position.x - pos.x;
		pos.x = position.x;
	elif(position.x < pos.x):
		displacement.x += pos.x - position.x;
		pos.x = position.x;
	if(abs(displacement.x) < attack_traversal.x && launched):
		if(speedx > 0):
			hspd -= 10*Direction;
			speedx = speedx - 10
		else:
			hspd = 0;
	elif(abs(displacement.x) > attack_traversal.x):
		hspd = 0;
		speedx = 0;
	pass;

func displacey():
	if(position.y > pos.y):
		displacement.y += position.y - pos.y;
		pos.y = position.y;
	elif(position.y < pos.y):
		displacement.y += pos.y - position.y;
		pos.y = position.y;
	if(abs(displacement.y) < attack_traversal.y && launched):
		if(speedy > 0):
			vspd -= 10*vDirection;
			speedy = speedy - 10
		else:
			vspd = 0;
	elif(abs(displacement.y) > attack_traversal.y):
		vspd = 0;
		speedy = 0;
	pass

func _on_WindupTimer_timeout():
	hspd = 0;
	col.disabled = false;
	visible = true;
	$AttackTimer.wait_time = attack;
	$AttackTimer.start();
	attack_state.attack_mid = true;
	attack_state.attack_start = false;
	launched = true;

	hspd = speedx * Direction;
	vspd = speedy * vDirection;
	pass;

### All attacks need versions of these ###
func _on_AttackTimer_timeout():
	queue_free();
	attack_state.attack_mid = false;
	attack_state.attack_end = true;
	attack_state.attack_spawned = false;
	attack_state.get_node("RecoilTimer").wait_time = recoil;
	attack_state.get_node("RecoilTimer").start();
	pass;

func on_area_entered(area):
	attack_state.hit = true;
	attack_state.air_counter = 1;
	pass;
