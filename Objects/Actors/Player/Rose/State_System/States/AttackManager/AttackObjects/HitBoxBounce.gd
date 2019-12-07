extends "./HitBoxParent.gd"

var check_bounce = false;
var bod;

func _physics_process(delta):
	if(check_bounce):
		if(host.is_on_wall() || host.is_on_floor() || host.is_on_ceiling()):
			check_bounce = false;
			host.get_node("Movement_States/Attack/Attack_Controller").bounce = true;
			host.get_node("Movement_States/Attack/Attack_Controller").on_hit(bod);

func _on_Area2D_body_entered(body):
	check_bounce = true;
	bod = body

func _on_Area2D_area_entered(area):
	if(area.host.hp > 0):
		host.get_node("Movement_States/Attack/Attack_Controller").bounce = true;
	._on_Area2D_area_entered(area);