extends "./HitBoxParent.gd"

func _on_RigidBody2D_body_entered(body):
	$Sprite.modulate.a = 1;
