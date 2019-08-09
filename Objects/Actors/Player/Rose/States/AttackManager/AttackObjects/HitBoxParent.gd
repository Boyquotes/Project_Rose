extends Area2D

enum KNOCKBACK_TYPE {AWAY, LINEAR, DIRECTIONAL, VORTEX};

export(float) var knockback;
export(KNOCKBACK_TYPE) var knockback_type;
export(float) var direction;
export(float) var inchdir = 1;
var true_knockback = 0;

var calc_direction = true;

func _ready():
	true_knockback = knockback;

func _physics_process(delta):
	true_knockback -= 12;

var host;