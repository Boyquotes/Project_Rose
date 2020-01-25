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
	hitNodeIdx.host = host;
	hitNodeIdx.z_index = 2;
	attack_controller.attack_start = false;
	var hitbox = get_hitbox(hitNodeIdx);
	hitbox.host = get_parent().get_parent().host;
	host.change_mana(-hitbox.cost);
	var partNode = get_partNode(hitNodeIdx);
	if(partNode != null):
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
	if(hitbox.has_node("Node2D")):
		return hitbox.get_node("Node2D");
	else:
		return null

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
			hitbox.scale.y = host.Direction;
		else:
			hitbox.scale.x = host.Direction;
			hitbox.direction = hitbox.global_rotation_degrees * host.Direction

### MELEE ATTACKS ###

func SlashPlusDodge():
	instance_SlashPlusDodge_hitbox();
	hitNode[hitNode.size()-1].init();

func Slash():
	instance_Slash_hitbox();
	hitNode[hitNode.size()-1].init();

func SlashSwirl():
	instance_SlashSwirl_hitbox();
	hitNode[hitNode.size()-1].init();

func BashLaunch():
	instance_BashLaunch_hitbox();
	
	var hitbox = get_hitbox(hitNode[hitNode.size()-1]);
	hitNode[hitNode.size()-1].init();

func Bash():
	instance_Bash_hitbox();
	
	hitNode[hitNode.size()-1].init();

func Pierce():
	instance_Pierce_hitbox();
	hitNode[hitNode.size()-1].init();

func PierceStasis():

	for hb in host.targettable_hitboxes:
		var c = hb.host;
		if(c.mark == 2):
			c.states['stun'].true_time = 2;
			c.states[c.state].exit(c.states['stun']);
			c.deactivate_grav();
			c.deactivate_fric();
			c.hspd = 0;
			c.vspd = 0;
			c.velocity = Vector2(0,0);
			hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Tether/Tether.tscn").instance());
			hitNode[hitNode.size()-1].host = host;
			hitNode[hitNode.size()-1].get_child(0).get_child(0).host = host;
			host.get_parent().add_child(hitNode[hitNode.size()-1]);
			hitNode[hitNode.size()-1].global_position = c.global_position;

func PierceLaunch():
	for t in hitNode:
		t.launch(host.deg);

func BashPlusDodge():
	instance_BashPlusDodge_Forward();
	instance_BashPlusDodge_Backward();
	set_rot(hitNode[hitNode.size()-2]);
	hitNode[hitNode.size()-1].scale.x = host.Direction;
	
	hitNode[hitNode.size()-2].init();
	hitNode[hitNode.size()-1].init();

### RANGED ATTACKS ###

func SlashWind():
	instance_SlashWind();
	
	throw(250);
	hitNode[hitNode.size()-1].init();

func PierceDash():
	instance_PierceDash_hitbox();
	
	hitNode[hitNode.size()-1].init();

func BashLunge():
	instance_BashLunge_hitbox();
	
	hitNode[hitNode.size()-1].init();

func throw(force):
	var hitbox = get_hitbox(hitNode[hitNode.size()-1]);
	var x = cos(hitbox.rotation) * force;
	var y = sin(hitbox.rotation) * force;
	hitbox.get_parent().apply_impulse(Vector2(0,0),Vector2(x,y));

### INSTANCING ###

func instance_SlashWind():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_SlashWind/SlashWind_Hitbox.tscn").instance());
	initialize_hitbox(hitNode[hitNode.size()-1]);

func instance_Slash_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Slash/Slash_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_SlashPlusDodge_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_SlashPlusDodge/SlashPlusDodge_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_BashLaunch_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_BashLaunch/BashLaunch_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_Bash_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Bash/Bash_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_BashPlusDodge_Forward():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_BashPlusDodge/BashPlusDodge_Hitbox_Forward.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_BashPlusDodge_Backward():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_BashPlusDodge/BashPlusDodge_Hitbox_Backward.tscn").instance());
	initialize_hitbox(hitNode[hitNode.size()-1]);

func instance_SlashSwirl_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_SlashSwirl/SlashSwirl_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_Pierce_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_Pierce/Pierce_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_PierceDash_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_PierceDash/PierceDash_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func instance_BashLunge_hitbox():
	hitNode.push_back(preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Event_BashLunge/BashLunge_Hitbox.tscn").instance());
	initialize_hitbox_attach(hitNode[hitNode.size()-1]);

func clear():
	for node in hitNode:
		if(is_instance_valid(node)):
			if("attached" in node):
				if(node.attached == true):
					node.global_rotation_degrees = 0;
					node.queue_free();
			else:
				node.queue_free();
	hitNode.clear();


