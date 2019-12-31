extends Node2D

var hitNode = [];

onready var attack_controller = get_parent();
onready var attack_state = get_parent().get_parent();
onready var host = get_parent().get_parent().get_parent().get_parent();

### GENERAL FUNCTIONS ### 

func connect_entered(hitbox):
	hitbox.attack_controller = attack_controller;
	hitbox.connect("body_entered",attack_controller,"on_hit");

func initialize_hitbox(hitNodeIdx):
	hitNodeIdx.z_index = 2;
	attack_controller.attack_start = false;
	var hitbox = get_hitbox(hitNodeIdx);
	hitbox.host = get_parent().get_parent().host;
	var partNode = get_partNode(hitNodeIdx);
	partNode.scale = scale
	connect_entered(hitbox);
	hitNodeIdx.scale = scale;
	host.get_parent().add_child(hitNodeIdx);
	hitNodeIdx.global_position = get_parent().global_position;
	set_rot(hitNode[hitNode.size()-1]);

func get_hitbox(hitNodeIdx):
	return hitNodeIdx.get_child(0);

func get_partNode(hitNodeIdx):
	var hitbox = get_hitbox(hitNodeIdx);
	return hitbox.get_node("Node2D");

func get_particle(hitNodeIdx):
	var partNode = get_partNode(hitNodeIdx)
	return partNode.get_child(0);

func initialize_hitbox_attach(hitNodeIdx):
	initialize_hitbox(hitNodeIdx);
	hitNodeIdx.follow = host;
	hitNodeIdx.attached = true;

func set_rot(hitNodeIdx):
	var hitbox = get_hitbox(hitNodeIdx);
	if(is_instance_valid(hitbox)):
		if(attack_controller.rotate):
			hitbox.global_rotation_degrees += attack_controller.attack_degrees;
			if(hitbox.direction == 0):
				hitbox.direction = hitbox.global_rotation_degrees * host.Direction
				
		else:
			hitbox.scale.x = host.Direction;
			hitbox.direction = hitbox.global_rotation_degrees * host.Direction

### MELEE ATTACKS ###

func SlashPlusDodge():
	instance_SlashPlusDodge_hitbox();
	hitNode[hitNode.size()-1].init();
	host.change_mana(-10);

func Slash():
	instance_Slash_hitbox();
	hitNode[hitNode.size()-1].init();
	

func SlashSlash():
	Slash();
	var particle = get_particle(hitNode[hitNode.size()-1]);
	particle.scale = Vector2(2.5, -1);

func ChargedSlash_Down_Ground():
	instance_ChargedSlash_Down_Ground_hitbox();
	hitNode[hitNode.size()-1].init();

func ChargedSlash_Down_Ground_Quick():
	instance_ChargedSlash_Down_Ground_hitbox();
	hitNode[hitNode.size()-1].scale /= 2;
	hitNode[hitNode.size()-1].init();

func ChargedSlash_Hor():
	instance_ChargedSlash_Hor_hitbox();
	hitNode[hitNode.size()-1].init();

func Bash_Directional():
	instance_Bash_Directional_hitbox();
	
	var hitbox = get_hitbox(hitNode[hitNode.size()-1]);
	hitNode[hitNode.size()-1].init();

func Bash():
	instance_Bash_hitbox();
	
	hitNode[hitNode.size()-1].init();

func BashBash():
	Bash();
	var particle = get_particle(hitNode[hitNode.size()-1]);
	var hitbox = get_hitbox(hitNode[hitNode.size()-1]);
	particle.scale *= Vector2(1, -1);
	hitbox.inchdir = -1;

func Pierce():
	instance_Pierce_hitbox();
	
	hitNode[hitNode.size()-1].init();

func UpgradedPierce():
	instance_UpgradedPierce_hitbox();
	
	hitNode[hitNode.size()-1].init();
	host.change_mana(-10);

func BashPlusDodge():
	instance_BashPlusDodge_Forward();
	instance_BashPlusDodge_Backward();
	set_rot(hitNode[hitNode.size()-2]);
	hitNode[hitNode.size()-1].scale.x = host.Direction;
	
	hitNode[hitNode.size()-2].init();
	hitNode[hitNode.size()-1].init();
	host.change_mana(-40);

### RANGED ATTACKS ###

func RangedSlash():
	instance_RangedSlash();
	
	throw(250);
	hitNode[hitNode.size()-1].init();
	host.change_mana(-30);

func RangedBash():
	instance_RangedBash();
	
	throw(800);
	hitNode[hitNode.size()-1].init();
	host.change_mana(-30);

func throw(force):
	var hitbox = get_hitbox(hitNode[hitNode.size()-1]);
	var x = cos(hitbox.rotation) * force;
	var y = sin(hitbox.rotation) * force;
	hitbox.get_parent().apply_impulse(Vector2(0,0),Vector2(x * get_parent().get_parent().host.Direction,y));

### INSTANCING ###

func instance_RangedSlash():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_RangedSlash/RangedSlash_Hitbox.tscn").instance());
	initialize_hitbox(hitNode[hitNode.size()-1]);

func instance_RangedBash():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_RangedBash/RangedBash_Hitbox.tscn").instance());
	initialize_hitbox(hitNode[hitNode.size()-1]);

func instance_Slash_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Slash/Slash_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_SlashPlusDodge_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_SlashPlusDodge/SlashPlusDodge_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_Bash_Directional_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_BashDirectional/BashDirectional_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_Bash_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Bash/Bash_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_ChargedSlash_Hor_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_ChargedSlash_Hor/ChargedSlash_Hor_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_BashPlusDodge_Forward():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_BashPlusDodge/BashPlusDodge_Hitbox_Forward.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_BashPlusDodge_Backward():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_BashPlusDodge/BashPlusDodge_Hitbox_Backward.tscn").instance());
	initialize_hitbox(hitNode[hitNode.size()-1]);

func instance_ChargedSlash_Down_Ground_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_ChargedSlash_Down_Ground/ChargedSlash_Down_Ground_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_Pierce_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Pierce/Pierce_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_UpgradedPierce_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_UpgradedPierce/UpgradedPierce_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

### NEEDS FIXING ###

func Closed_Fan_QuickX_Hor():
	instance_bash_QuickX_hitbox();
	var particle = get_particle(hitNode[hitNode.size()-1]);
	particle.lifetime = .2;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(2, .5);
	particle.emitting = true;
	$particleTimer.start(.2);

func Hurricane():
	instance_Hurricane_hitbox();
	var particle = get_particle(hitNode[hitNode.size()-1]);
	var partNode = get_partNode(hitNode[hitNode.size()-1]);
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
	

func instance_Hurricane_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Old_Hitboxes/Wind_Dance/Y.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_bash_QuickX_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Old_Hitboxes/Closed_Fan/QuickX.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func clear():
	for node in hitNode:
		if(is_instance_valid(node) && node.attached):
			node.global_rotation_degrees = 0;
			node.queue_free();
	hitNode.clear();