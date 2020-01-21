extends "./Free_Motion_State.gd"

export(float) var cost = 2;

onready var hitbox = get_node("VortexAttackBox/CollisionShape2D");

func _ready():
	hitbox.disabled = true;

func enter():
	host.can_channel_and_focus = false;
	host.regain_mana = false;
	hitbox.disabled = false;
	host.iframe = true;
	$costTimer.start();
	host.move_state = 'vortex';
	update_look_direction_and_scale(1);

func handleAnimation():
	host.animate(host.spr_anim,"Vortex", false);
	host.get_node("Sprites").rotation = host.rad;

func handleInput():
	if(hitbox.disabled):
		hitbox.disabled = false;
	if(Input.is_action_just_pressed("Jump")):
		exit_g_or_a();
		return;
	if(host.mana < cost):
		exit_g_or_a();
		return;
	if((Input.is_action_just_pressed("Move_Down") || 
	Input.is_action_just_pressed("Move_Left") || 
	Input.is_action_just_pressed("Move_Right") || 
	Input.is_action_just_pressed("Move_Up")) &&
	$hitTimer.is_stopped()):
		$hitTimer.start();

func execute(delta):
	host.vspd = sin(host.rad) * host.base_mspd * 1.2;
	host.hspd = cos(host.rad) * host.base_mspd * 1.2;
	$VortexAttackBox.direction = host.deg;

func exit(state):
	host.can_channel_and_focus = true;
	host.regain_mana = true;
	$costTimer.stop();
	hitbox.disabled = true;
	host.set_rotation_to_origin("Sprites");
	.exit(state);

func _on_costTimer_timeout():
	host.change_mana(-cost);


func _on_hitTimer_timeout():
	hitbox.disabled = true;
