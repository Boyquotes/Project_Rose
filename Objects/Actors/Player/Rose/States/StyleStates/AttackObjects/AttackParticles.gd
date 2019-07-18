extends Node2D

var partNode;
var particle;
var hitNode;
var hitbox;

onready var attack_state = get_parent().get_node("Movement_States").get_node("Attack");

func instance_slash_particle():
	partNode = preload("res://Objects/Actors/Player/Rose/States/StyleStates/AttackObjects/SlashParticles.tscn").instance();
	particle = partNode.get_child(0);
	partNode.scale = scale;
	get_parent().add_child(partNode);
	partNode.global_position = get_parent().global_position;

func connect_entered():
	var style_state = attack_state.style_states[attack_state.style_state];
	hitbox.connect("area_entered",style_state,"on_hit");

func instance_hitbox():
	hitbox = hitNode.get_child(0);
	hitbox.host = get_parent();
	connect_entered();
	hitNode.scale = scale;
	get_parent().add_child(hitNode);
	hitNode.global_position = get_parent().global_position;

func instance_X_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/StyleStates/AttackObjects/X.tscn").instance();
	instance_hitbox();

func instance_XplusB_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/StyleStates/AttackObjects/X+B.tscn").instance();
	instance_hitbox();

func instance_HoldX_Hor_Ground_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/StyleStates/AttackObjects/HoldX_Hor_Ground.tscn").instance();
	instance_hitbox();

func instance_HoldX_Down_Ground_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/StyleStates/AttackObjects/HoldX_Down_Ground.tscn").instance();
	instance_hitbox();

func instance_Y_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/StyleStates/AttackObjects/Y.tscn").instance();
	instance_hitbox();

func Wind_Dance_XplusB():
	instance_slash_particle();
	instance_XplusB_hitbox();
	particle.z_index = 1;
	particle.amount = 1;
	particle.lifetime = .4;
	particle.process_material.gravity = Vector3(0,-250,0);
	particle.process_material.angular_velocity = 1000;
	particle.process_material.angular_velocity_random = 0;
	particle.process_material.angular_velocity_curve = CurveTexture.new();
	particle.process_material.angular_velocity_curve.curve.add_point(Vector2(0,0));
	particle.process_material.angular_velocity_curve.curve.add_point(Vector2(-360,1));
	particle.process_material.scale = 2;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(.8, 0.25);
	particle.emitting = true;
	$particleTimer.start(.4);

func Wind_Dance_HoldX_Down_Ground():
	instance_slash_particle();
	instance_HoldX_Down_Ground_hitbox();
	particle.lifetime = .3;
	particle.process_material.angular_velocity = 1000;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(3, 0.5);
	particle.emitting = true;
	$particleTimer.start(.3);

func Wind_Dance_HoldX_Hor_Ground():
	instance_slash_particle();
	instance_HoldX_Hor_Ground_hitbox();
	particle.lifetime = .3;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 78.5;
	particle.scale = Vector2(1.65, 4);
	particle.emitting = true;
	$particleTimer.start(.3);

func Wind_Dance_X_Hor():
	instance_slash_particle();
	instance_X_hitbox();
	particle.lifetime = .2;
	particle.process_material.angular_velocity = 750;
	particle.rotation_degrees = 10;
	particle.scale = Vector2(2.5, 1);
	particle.emitting = true;
	$particleTimer.start(.2);

func Wind_Dance_XX_Hor():
	instance_slash_particle();
	instance_X_hitbox();
	particle.lifetime = .2;
	particle.process_material.angular_velocity = 750;
	particle.rotation_degrees = -10;
	particle.scale = Vector2(2.5, -1);
	particle.emitting = true;
	$particleTimer.start(.2);

func Wind_Dance_X_Up():
	Wind_Dance_X_Hor();
	hitbox.rotation_degrees -= 90;
	particle.rotation_degrees -= 90;

func Wind_Dance_XX_Up():
	Wind_Dance_XX_Hor();
	hitbox.rotation_degrees -= 90;
	particle.rotation_degrees -= 90;

func Wind_Dance_X_Down_Air():
	Wind_Dance_X_Hor();
	hitbox.rotation_degrees += 90;
	particle.rotation_degrees += 90;

func Wind_Dance_XX_Down_Air():
	Wind_Dance_XX_Hor();
	hitbox.rotation_degrees += 90;
	particle.rotation_degrees += 90;

func Wind_Dance_Y_Hor():
	instance_slash_particle();
	instance_Y_hitbox();
	#TODO: make specific hitbox
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
	$particleTimer.start(.45);

func Wind_Dance_Y_Down_Air():
	Wind_Dance_Y_Hor();
	hitbox.rotation_degrees += 90;
	particle.rotation_degrees += 90;

func Wind_Dance_Y_Up():
	Wind_Dance_Y_Hor();
	hitbox.rotation_degrees -= 90;
	particle.rotation_degrees -= 90;

func Wind_Dance_Y_Hor_Up():
	Wind_Dance_Y_Hor();
	hitbox.rotation_degrees -= 45;
	particle.rotation_degrees -= 45;

func Wind_Dance_Y_Hor_Down():
	Wind_Dance_Y_Hor();
	hitbox.rotation_degrees += 45;
	particle.rotation_degrees += 45;

func slash_emit_off():
	particle.emitting = false;

func _on_particleTimer_timeout():
	
	particle.process_material.gravity = Vector3(0,0,0);
	particle.process_material.angular_velocity_random = 0;
	if(particle.process_material.angular_velocity_curve):
		particle.process_material.angular_velocity_curve = null;
	particle.process_material.scale_random = 0;
	if(particle.process_material.scale_curve):
		particle.process_material.scale_curve = null;
	particle.rotation_degrees = 0
	hitbox.rotation_degrees = 0
	particle.z_index = 0;
	partNode.queue_free()
	particle.queue_free();
	hitNode.queue_free();
	hitbox.queue_free();