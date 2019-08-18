extends Node2D

var partNode;
var particle;
var hitNode;
var hitbox;

onready var attack_controller = get_parent();
onready var attack_state = get_parent().get_parent();
onready var host = get_parent().get_parent().get_parent().get_parent();

### GENERAL FUNCTIONS ### 

func connect_entered():
	var attack_controller = attack_state.attack_controller;
	hitbox.connect("area_entered",attack_controller,"on_hit");

func instance_hitbox():
	attack_controller.attack_start = false;
	hitbox = hitNode.get_child(0);
	hitbox.host = get_parent().get_parent().host;
	partNode = hitbox.get_node("Node2D");
	particle = partNode.get_child(0);
	partNode.scale = scale
	connect_entered();
	hitNode.scale = scale;
	get_parent().add_child(hitNode);
	hitNode.global_position = get_parent().global_position;

func instance_ranged_hitbox():
	attack_controller.attack_start = false;
	hitbox = hitNode.get_child(0);
	hitbox.host = get_parent().get_parent().host;
	partNode = hitbox.get_node("Node2D");
	particle = partNode.get_child(0);
	partNode.scale = scale
	connect_entered();
	host.get_parent().add_child(hitNode);
	hitNode.scale = scale;
	hitNode.global_position = get_parent().global_position;

func set_rot():
	if(is_instance_valid(hitbox)):
		hitbox.global_rotation_degrees += attack_controller.attack_degrees;
		if(hitbox.direction == 0):
			hitbox.direction = hitbox.global_rotation_degrees * host.Direction

### ATTACKS ###

func SlashPlusDodge():
	instance_SlashPlusDodge_hitbox();
	hitNode.init(.4);

func Slash():
	instance_Slash_hitbox();
	particle.emitting = true;
	hitNode.init(.2);
	set_rot();

func SlashSlash():
	Slash();
	particle.rotation_degrees = -10;
	particle.scale = Vector2(2.5, -1);

func ChargedSlash_Down_Ground():
	instance_ChargedSlash_Down_Ground_hitbox();
	hitNode.init(.3);

func ChargedSlash_Hor():
	instance_ChargedSlash_Hor_hitbox();
	hitNode.init(.3);

func Bash_Directional():
	instance_Bash_Directional_hitbox();
	set_rot();
	if(hitbox.global_rotation_degrees == -135):
		hitNode.scale *= Vector2(1,-1);
		hitNode.rotation_degrees += 90;
	if(hitbox.global_rotation_degrees == 45):
		hitNode.scale *= Vector2(1,-1);
		hitNode.rotation_degrees += 90;
	if(round(hitbox.global_rotation_degrees) == 90 && host.Direction == 1):
		hitNode.scale *= Vector2(-1,1);
	if(round(hitbox.global_rotation_degrees) == -90 && host.Direction == -1):
		hitNode.scale *= Vector2(-1,1);
	hitNode.init(.4);

func Bash():
	instance_Bash_hitbox();
	hitNode.init(.3);

func BashBash():
	Bash();
	particle.scale *= Vector2(1, -1);
	hitbox.inchdir = -1;

func Pierce():
	instance_Pierce_hitbox();
	set_rot();
	hitNode.init(.25);

func UpgradedPierce():
	instance_UpgradedPierce_hitbox();
	set_rot();
	hitNode.init(.25);

func RangedSlash():
	instance_RangedSlash();
	set_rot();
	throw(250);
	hitNode.init(1.5);

func RangedBash():
	instance_RangedBash();
	set_rot();
	throw(800);
	hitNode.init(1);

func throw(force):
	var x = cos(hitbox.rotation) * force;
	var y = sin(hitbox.rotation) * force;
	hitbox.get_parent().apply_impulse(Vector2(0,0),Vector2(x * get_parent().get_parent().host.Direction,y));

### INSTANCING ###

func instance_RangedSlash():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_RangedSlash/RangedSlash_Hitbox.tscn").instance();
	instance_ranged_hitbox();

func instance_RangedBash():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_RangedBash/RangedBash_Hitbox.tscn").instance();
	instance_ranged_hitbox();

func instance_Slash_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Slash/Slash_Hitbox.tscn").instance();
	instance_hitbox();

func instance_SlashPlusDodge_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_SlashPlusDodge/SlashPlusDodge_Hitbox.tscn").instance();
	instance_hitbox();

func instance_Bash_Directional_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_BashDirectional/BashDirectional_Hitbox.tscn").instance();
	instance_hitbox();

func instance_Bash_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Bash/Bash_Hitbox.tscn").instance();
	instance_hitbox();

func instance_ChargedSlash_Hor_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_ChargedSlash_Hor/ChargedSlash_Hor_Hitbox.tscn").instance();
	instance_hitbox();

func instance_ChargedSlash_Down_Ground_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_ChargedSlash_Down_Ground/ChargedSlash_Down_Ground_Hitbox.tscn").instance();
	instance_hitbox();

func instance_Pierce_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Pierce/Pierce_Hitbox.tscn").instance();
	instance_hitbox();

func instance_UpgradedPierce_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_UpgradedPierce/UpgradedPierce_Hitbox.tscn").instance();
	instance_hitbox();

### NEEDS FIXING ###

func Closed_Fan_QuickX_Hor():
	instance_bash_QuickX_hitbox();
	particle.lifetime = .2;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(2, .5);
	particle.emitting = true;
	$particleTimer.start(.2);

func Hurricane():
	instance_Hurricane_hitbox();
	particle.one_shot = false;
	particle.z_index = 5;
	particle.amount = 10
	particle.lifetime = .3;
	particle.process_material.gravity = Vector3(-500,0,0);
	particle.process_material.angular_velocity = 1000;
	particle.process_material.angular_velocity_random = 1;
	particle.process_material.scale = 1;
	particle.process_material.scale_random = 0.4;
	particle.process_material.scale_curve = CurveTexture.new();
	particle.process_material.scale_curve.curve.add_point(Vector2(0,0.5));
	particle.process_material.scale_curve.curve.add_point(Vector2(1,1));
	particle.rotation_degrees = 0;
	particle.scale = Vector2(3, 1);
	particle.emitting = true;
	partNode.time = .35;
	hitNode.time = .35;
	hitNode.init();
	partNode.init();
	set_rot();

func instance_Hurricane_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Old_Hitboxes/Wind_Dance/Y.tscn").instance();
	instance_hitbox();

func instance_bash_QuickX_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Old_Hitboxes/Closed_Fan/QuickX.tscn").instance();
	instance_hitbox();
