extends "./HitBoxParent.gd"

func _on_Area2D_area_entered(area):
	#TODO: add check to make sure the area is an enemy
	if(area.host.hp > 0):
		host.get_node("Movement_States/Attack/Attack_Controller").tether = true;
		print("!!!");
		host.get_node("Movement_States/Attack/Attack_Controller").tethered_creature = area.host;
	._on_Area2D_area_entered(area);