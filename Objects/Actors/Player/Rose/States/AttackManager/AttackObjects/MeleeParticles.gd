extends "./AttackParticles.gd"

func SlashPlusDodge():
	instance_slash_particle();
	instance_SlashPlusDodge_hitbox();
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
	hitNode.time = .4;

func Slash():
	instance_slash_particle();
	instance_Slash_hitbox();
	particle.lifetime = .2;
	particle.process_material.angular_velocity = 750;
	particle.rotation_degrees = 10;
	particle.scale = Vector2(2.5, 1);
	particle.emitting = true;
	hitNode.time = .2;
	set_rot();

func SlashSlash():
	Slash();
	particle.rotation_degrees = -10;
	particle.scale = Vector2(2.5, -1);

func ChargedSlash_Down_Ground():
	instance_slash_particle();
	instance_ChargedSlash_Down_Ground_hitbox();
	particle.lifetime = .3;
	particle.process_material.angular_velocity = 1000;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(3, 0.5);
	particle.emitting = true;
	hitNode.time = .3;

func ChargedSlash_Hor():
	instance_slash_particle();
	instance_ChargedSlash_Hor_hitbox();
	particle.lifetime = .3;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 78.5;
	particle.scale = Vector2(1.65, 4);
	particle.emitting = true;
	hitNode.time = .3;

func Bash_Directional():
	instance_bash_particle();
	instance_Bash_Directional_hitbox();
	particle.lifetime = .4;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 90;
	particle.scale = Vector2(1.5, 4);
	particle.emitting = true;
	hitbox.rotation_degrees = 0;
	hitNode.time = .4;
	set_rot();
	if(hitbox.global_rotation_degrees == -135):
		hitNode.scale *= Vector2(1,-1);
		hitNode.rotation_degrees += 90;
		particle.scale *= Vector2(-1,1);
	if(hitbox.global_rotation_degrees == 45):
		hitNode.scale *= Vector2(1,-1);
		hitNode.rotation_degrees += 90;
		particle.scale *= Vector2(-1,1);
	if(round(hitbox.global_rotation_degrees) == 90 && host.Direction == 1):
		hitNode.scale *= Vector2(-1,1);
		particle.scale *= Vector2(-1,1);
	if(round(hitbox.global_rotation_degrees) == -90 && host.Direction == -1):
		hitNode.scale *= Vector2(-1,1);
		particle.scale *= Vector2(-1,1);

func Bash():
	instance_bash_particle();
	instance_Bash_hitbox();
	particle.lifetime = .3;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(1.5, 1);
	particle.emitting = true;
	hitNode.time = .3;

func BashBash():
	Bash();
	particle.scale *= Vector2(1, -1);
	hitNode.time = .3;
	hitbox.inchdir = -1;

func Pierce():
	instance_Pierce_hitbox();
	hitNode.time = 1;
	set_rot();

func instance_Slash_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Slash.tscn").instance();
	instance_hitbox();

func instance_SlashPlusDodge_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/SlashPlusDodge.tscn").instance();
	instance_hitbox();

func instance_bash_particle():
	partNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/BashParticles.tscn").instance();
	instance_particle();
	
func instance_Bash_Directional_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Bash_Directional.tscn").instance();
	instance_hitbox();

func instance_Bash_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Bash.tscn").instance();
	instance_hitbox();

func instance_ChargedSlash_Hor_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/ChargedSlash_Hor.tscn").instance();
	instance_hitbox();

func instance_ChargedSlash_Down_Ground_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/ChargedSlash_Down_Ground.tscn").instance();
	instance_hitbox();

func instance_slash_particle():
	partNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/SlashParticles.tscn").instance();
	instance_particle();

func instance_Pierce_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Pierce.tscn").instance();
	instance_hitbox();

func Closed_Fan_QuickX_Hor():
	instance_bash_particle();
	instance_bash_QuickX_hitbox();
	particle.lifetime = .2;
	particle.process_material.angular_velocity = 500;
	particle.rotation_degrees = 0;
	particle.scale = Vector2(2, .5);
	particle.emitting = true;
	$particleTimer.start(.2);

func Hurricane():
	instance_slash_particle();
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
	$particleTimer.start(.45);
	set_rot();

func instance_Hurricane_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Wind_Dance/Y.tscn").instance();
	instance_hitbox();

func instance_bash_QuickX_hitbox():
	hitNode = preload("res://Objects/Actors/Player/Rose/States/AttackManager/AttackObjects/Closed_Fan/QuickX.tscn").instance();
	instance_hitbox();