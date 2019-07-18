extends Area2D

enum KNOCKBACK_TYPE {AWAY, LINEAR, VORTEX};

export(float) var knockback;
export(KNOCKBACK_TYPE) var knockback_type;

var true_knockback = 0;

func _ready():
	true_knockback = knockback;

func _physics_process(delta):
	true_knockback -= 12;

var host;