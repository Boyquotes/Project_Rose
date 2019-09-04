extends "res://Objects/Actors/Enemies/Enemy.gd"

export(float) var orbit_threshold = 50;

func _ready():
	states = {
	'default' : $States/Default,
	'chase' : $States/Chase,
	'hurt' : $States/Hurt,
	'stun' : $States/Stun,
	'orbit' : $States/Orbit,
	'backup' : $States/Backup,
	'attack' : $States/Attack
	};
	grav_activated = false;
	._ready();

func phys_execute(delta):
	#state machine
	#state = 'default' by default
	states[state].handleAnimation();
	states[state].handleInput(Input);
	states[state].execute(delta);
	
	velocity.x = hspd;
	velocity.y = vspd;
	velocity = move_and_slide(velocity,floor_normal);
	#no gravity acceleration when on floor
	
	#add gravity
	if(grav_activated):
		vspd += true_gravity;
	
	#cap gravity
	if(vspd > 900):
		vspd = 900;
	
	if(fric_activated && !moving):
		if(hspd > 0):
			hspd -= friction;
		elif(hspd < 0):
			hspd += friction;
		if(abs(hspd) <= friction):
			hspd = 0;

func Kill():
	var part = preload("./Death_Particle.tscn").instance();
	get_parent().add_child(part);
	part.global_position = global_position;
	part.scale.x = Direction;
	.Kill();