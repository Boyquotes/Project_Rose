extends "res://Objects/Actors/Enemies/DamagePlayerHitbox.gd"

func _on_Area2D_area_entered(area):
	get_parent().queue_free();

func _on_RigidBody2D_body_entered(body):
	get_parent().queue_free();
