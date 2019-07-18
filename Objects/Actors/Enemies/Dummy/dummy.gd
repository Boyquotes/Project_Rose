extends "res://Objects/Actors/Actor.gd"


var friction = 10;
var damaged = false;
func _physics_process(delta):
	#move across surfaces
	velocity.y = vspd;
	velocity.x = hspd;
	velocity = move_and_slide(velocity, floor_normal);
	
	#no gravity acceleration when on floor
	if(is_on_floor() && !damaged):
		velocity.y = 0
		vspd = 0;
		friction = 10;
	
	if(grav_activated):
		vspd += gravity;
	
	#cap gravity
	if(vspd > 450):
		vspd = 450;
	
	if(is_on_ceiling()):
		vspd = 0;
	
	if(fric_activated):
		if(hspd > 0):
			hspd -= friction;
		elif(hspd < 0):
			hspd += friction;
		if((hspd <= 44 && hspd > 0) || (hspd >= 44 && hspd < 0)):
			hspd = 0;
	
	if(damaged):
		if(abs(hspd) > 0):
			if(abs(hspd) < 2):
				hspd = 0;
			hspd -= 2 * sign(hspd);
		if(abs(vspd) > 0):
			if(abs(vspd) < 3):
				vspd = 0;
			vspd -= 3 * sign(vspd);
	pass;

func _on_damage_timer_timeout():
	damaged = false;
	activate_fric();
	activate_grav();
	pass;
