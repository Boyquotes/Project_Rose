extends "./Free_Motion_State.gd"

export(float) var cost = 2;
var deg = 0;
var hit_wall = false;

onready var physbox = get_parent().get_parent().get_node("Sprites/Sprite/ChargePhysBox/CollisionShape2D");
onready var hitbox = get_node("ChargeAttackBox/CollisionShape2D");

func _ready():
	physbox.disabled = true;
	hitbox.disabled = true;

func enter():
	physbox.disabled = false;
	hitbox.disabled = false;
	host.can_channel_and_focus = false;
	host.regain_mana = false;
	$costTimer.start();
	host.move_state = 'charge';
	update_look_direction_and_scale(1);

func handleAnimation():
	host.animate(host.spr_anim,"Charge", false);
	deg = attack.get_child(0).attack_degrees;
	host.get_node("Sprites/Sprite").rotation_degrees = deg;

func handleInput():
	if(Input.is_action_just_pressed("Jump")):
		exit_g_or_a();
		return;
	if(host.mana < cost):
		exit_g_or_a();
		return;
	if(hit_wall):
		exit_g_or_a();
		return;

func execute(delta):
	host.vspd = sin(deg2rad(deg)) * host.base_mspd * 3;
	host.hspd = cos(deg2rad(deg)) * host.base_mspd * 3;

func exit(state):
	physbox.disabled = true;
	hitbox.disabled = true;
	hit_wall = false;
	host.can_channel_and_focus = true;
	host.regain_mana = true;
	$costTimer.stop();
	host.set_rotation_to_origin("Sprites/Sprite");
	.exit(state);

func _on_costTimer_timeout():
	host.change_mana(-cost);

func _on_ChargePhysBox_area_entered(area):
	hit_wall = true;
	host.get_node("Camera2D").shake(.1, 15, 8);

func _on_ChargePhysBox_body_entered(body):
	hit_wall = true;
	host.get_node("Camera2D").shake(.1, 15, 8);