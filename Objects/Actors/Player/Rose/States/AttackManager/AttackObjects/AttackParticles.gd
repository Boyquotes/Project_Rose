extends Node2D

var partNode;
var particle;
var hitNode;
var hitbox;

onready var attack_manager = get_parent();
onready var attack_state = get_parent().get_parent();
onready var host = get_parent().get_parent().get_parent().get_parent();

### GENERAL FUNCTIONS ### 

func instance_particle():
	particle = partNode.get_child(0);
	partNode.scale = scale;
	get_parent().add_child(partNode);
	partNode.global_position = get_parent().global_position;

func connect_entered():
	var attack_manager = attack_state.attack_manager;
	hitbox.connect("area_entered",attack_manager,"on_hit");

func instance_hitbox():
	attack_manager.attack_start = false;
	hitbox = hitNode.get_child(0);
	hitbox.host = get_parent().get_parent().host;
	connect_entered();
	hitNode.scale = scale;
	get_parent().add_child(hitNode);
	hitNode.global_position = get_parent().global_position;

func set_rot():
	if(is_instance_valid(hitbox)):
		hitbox.global_rotation_degrees += attack_manager.attack_degrees;
		if(hitbox.direction == 0):
			hitbox.direction = hitbox.global_rotation_degrees * host.Direction
	if(is_instance_valid(particle)):
		particle.global_rotation_degrees += attack_manager.attack_degrees;

func emit_off():
	particle.emitting = false;