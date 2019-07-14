extends Node2D

func Wind_Dance_HoldX_Down_Ground():
	$SlashParticle.scale = Vector2(3.5, 0.5);
	$SlashParticle.emitting = true;
	$particleTimer.start(.3);

func _on_particleTimer_timeout():
	for child in get_children():
		if "emitting" in child:
			print(child.one_shot);
			child.emitting = false;
			child.scale = Vector2(1,1);