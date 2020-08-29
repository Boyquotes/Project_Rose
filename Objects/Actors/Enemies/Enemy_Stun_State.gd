extends "res://Objects/Actors/Enemies/Enemy_State.gd"
export(float) var base_time = 1;
var true_time = 0;
var stunned = false;
enum STUN_TYPE {KNOCKED, FLINCHED, STUNNED, NILL}
enum KNOCKBACK_TYPE {AWAY, LINEAR, DIRECTIONAL, VORTEX, NILL};

var stun_type = STUN_TYPE.NILL;
var knockback_type = KNOCKBACK_TYPE.NILL;

var knockback;

func _ready():
	true_time = base_time;

func enter():
	if(stun_type == STUN_TYPE.NILL):
		exit(default);
		return;
	if(stun_type == STUN_TYPE.KNOCKED):
		knockback();
		exit(default);
		return;
	host.state = 'stun';

func handleAnimation():
	pass;

func handleInput(event):
	pass;

func execute(delta):
	pass;

func exit(state):
	stun_type = STUN_TYPE.NILL;
	knockback_type = KNOCKBACK_TYPE.NILL;
	.exit(state)

func knockback():
	pass;

func _on_stunTimer_timeout():
	stunned = false;
	true_time = base_time;
	host.activate_grav();
	host.activate_fric();
	exit(default);
