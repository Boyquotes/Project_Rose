extends Node2D

export(float) var time = .2;

func _ready():
	var anim = $AnimationPlayer.get_animation("New Anim");
	anim.length = time;
	anim.track_insert_key(0,time,{"method": "cleanup", "args": []});
	$AnimationPlayer.play("New Anim");

func cleanup():
	$Particles2D.process_material.gravity = Vector3(0,0,0);
	$Particles2D.process_material.angular_velocity_random = 0;
	if($Particles2D.process_material.angular_velocity_curve):
		$Particles2D.process_material.angular_velocity_curve = null;
	$Particles2D.process_material.scale_random = 0;
	if($Particles2D.process_material.scale_curve):
		$Particles2D.process_material.scale_curve = null;
	$Particles2D.process_material.scale = 1;
	$Particles2D.rotation_degrees = 0
	$Particles2D.z_index = 0;
	$Particles2D.scale = Vector2(1,1);
	queue_free();