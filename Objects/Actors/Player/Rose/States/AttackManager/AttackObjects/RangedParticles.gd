extends "./AttackParticles.gd"

func instance_hitbox():
	hitbox = hitNode.get_child(0).get_child(0);
	hitbox.host = get_parent().get_parent().host;
	connect_entered();
	get_parent().get_parent().host.get_parent().add_child(hitNode);
	hitNode.global_position = get_parent().global_position;

func Pierce():
	instance_Pierce_sprite();
	instance_Pierce_hitbox();
	set_rot();
	var force = 800;
	var x = cos(hitbox.rotation) * force;
	var y = sin(hitbox.rotation) * force;
	hitbox.get_parent().apply_impulse(Vector2(0,0),Vector2(x * get_parent().get_parent().host.Direction,y));

func WindAttack():
	instance_WindAttack();
	set_rot();
	var force = 250;
	var x = cos(hitbox.rotation) * force;
	var y = sin(hitbox.rotation) * force;
	hitbox.get_parent().apply_impulse(Vector2(0,0),Vector2(x * get_parent().get_parent().host.Direction,y));

func RockAttack():
	instance_RockAttack();
	set_rot();
	var force = 800;
	var x = cos(hitbox.rotation) * force;
	var y = sin(hitbox.rotation) * force;
	hitbox.get_parent().apply_impulse(Vector2(0,0),Vector2(x * get_parent().get_parent().host.Direction,y));

func instance_Pierce_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Pierce.tscn").instance();
	instance_hitbox();

func instance_Pierce_sprite():
	partNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Pierce_Sprite.tscn").instance();
	instance_particle();

func instance_WindAttack():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/WindAttack.tscn").instance();
	instance_hitbox();

func instance_RockAttack():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/RockAttack.tscn").instance();
	instance_hitbox();