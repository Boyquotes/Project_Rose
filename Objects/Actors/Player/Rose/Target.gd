extends Node2D

var item_trace = [];
var target;
onready var host = get_parent();
var rad=0;
var trad=0;
var x = 0;
var y = 0;
var tween = Tween.new();

func _ready():
	add_child(tween);

func execute(delta):
	
	if(host.active_input == host.InputType.KEYMOUSE):
		y = get_global_mouse_position().y - global_position.y
		x = get_global_mouse_position().x - global_position.x
	elif(host.active_input == host.InputType.GAMEPAD):
		if(abs(Input.get_joy_axis(0,JOY_ANALOG_RY))>.2 || abs(Input.get_joy_axis(0,JOY_ANALOG_RX))>.2):
			y = Input.get_joy_axis(0, JOY_ANALOG_RY)
			x = Input.get_joy_axis(0, JOY_ANALOG_RX)
		elif(abs(Input.get_joy_axis(0,JOY_ANALOG_LY))>.2 || abs(Input.get_joy_axis(0,JOY_ANALOG_LX))>.2):
			y = Input.get_joy_axis(0, JOY_ANALOG_LY)
			x = Input.get_joy_axis(0, JOY_ANALOG_LX)
	
	if(nextRay(host, $Sprite2, get_world_2d().direct_space_state)):
		y = target.global_position.y - global_position.y
		x = target.global_position.x - global_position.x
	trad = atan2(y , x)
	
	
	if(trad < -PI/2 && rad > PI/2):
		tween.interpolate_property(
		self, "rad", 
		rad, PI + 0.1, .025,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	elif(rad < -PI/2 && trad > PI/2):
		tween.interpolate_property(
		self, "rad", 
		rad, -PI - 0.1, .025,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	else:
		tween.interpolate_property(
		self, "rad", 
		rad, trad, .025,
		Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	tween.start()
	
	if(rad > PI):
		rad = -PI + (rad - PI);
		tween.stop(self,"rad")
	elif(rad < -PI):
		rad = PI + (rad + PI);
		tween.stop(self,"rad")
		print(String(rad) + " " + String(trad));
	return rad;

#the logic to determine if a specific hitbox can be hit
func nextRay(origin,dest,spc):
	var result = spc.intersect_ray(origin.global_position, dest.global_position, item_trace, host.AttackCollision.collision_mask);
	if(result.empty()):
		target = null;
		return false;
	elif("attack_type" in result.collider):
		print(result);
		target = result.collider;
		return true;
	else:
		target = null;
		return false;