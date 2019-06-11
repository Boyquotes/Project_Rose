extends Node2D

var host;
var attack_state;
var dam;
onready var col = get_node("collider");
export(float) var wind = .1;
export(float) var attack = .1;
export(float) var recoil = .1;
export(float) var speedx = 200;
export(float) var speedy = 200;
export(float) var fl = .6;
export(int) var mDir = 1;
export(Vector2) var knockback = Vector2(50,50);
var pos = Vector2(0,0);
var displacement = Vector2(0,0);
var attack_traversal = Vector2(0,0);
export(int) var vDirection = 1;

func _ready():
	connect("area_entered", self, "on_area_entered");
	connect("body_entered", self, "on_body_entered");
	initialize();
	pass;

func initialize():
	if(host.Direction == -1):
		scale.x = scale.x * -1;
		rotation = -rotation;
	$WindupTimer.wait_time = wind;
	$WindupTimer.start();
	col.disabled = true;
	visible = false;
	pos = host.position
	attack_traversal.x = attack_state.distance_traversable;
	attack_traversal.y = attack_state.distance_traversable;
	pass;

func displacex():
	if(host.position.x > pos.x):
		displacement.x += host.position.x - pos.x;
		pos.x = host.position.x;
	elif(host.position.x < pos.x):
		displacement.x += pos.x - host.position.x;
		pos.x = host.position.x;
	if(abs(displacement.x) < attack_traversal.x && attack_state.dashing):
		if(host.on_floor() && !attack_state.dashing):
			host.hspd = 0;
			speedx = 0;
		if(host.hspd > 0.5):
			host.hspd -= 25*host.Direction;
			speedx -= 25
		elif(host.hspd < -0.5):
			host.hspd -= 25*host.Direction;
			speedx -= 25*host.Direction;
	elif(abs(displacement.x) > attack_traversal.x):
		host.hspd = 0;
		speedx = 0;
		attack_state.dashing = false;
	pass;

func displacey():
	if(host.position.y > pos.y):
		displacement.y += host.position.y - pos.y;
		pos.y = host.position.y;
	elif(host.position.y < pos.y):
		displacement.y += pos.y - host.position.y;
		pos.y = host.position.y;
	if(abs(displacement.y) < attack_traversal.y && attack_state.dashing):
		if(host.on_floor() && !attack_state.dashing):
			host.vspd = 0;
			speedy = 0;
		if(host.vspd > 0.5):
			host.vspd -= 25*host.Direction;
			speedy -= 25;
		elif(host.vspd < -0.5):
			host.vspd -= 25*vDirection;
			speedy -= 25*vDirection;
	elif(abs(displacement.y) > attack_traversal.y):
		host.vspd = 0;
		speedy = 0;
		attack_state.dashing = false;
	pass

### All attacks need versions of these ###
func _on_AttackTimer_timeout():
	queue_free();
	attack_state.attack_mid = false;
	attack_state.attack_end = true;
	attack_state.attack_spawned = false;
	pass;


func _on_WindupTimer_timeout():
	col.disabled = false;
	visible = true;
	$AttackTimer.wait_time = attack;
	$AttackTimer.start();
	attack_state.attack_mid = true;
	attack_state.attack_start = false;
	pass;

func on_area_entered(area):
	attack_state.hit = true;
	attack_state.air_counter = 1;
	pass;

func on_body_entered(body):
	pass;