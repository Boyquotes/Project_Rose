extends "res://Objects/Actors/HitBoxCleanup.gd"

func _ready():
	$Sprites/Sprite.self_modulate.a = 0;
	$Sprites/Sprite/Area2D/CollisionShape2D.disabled = true;
	$Sprites/Sprite2.self_modulate.a = 0;
	$Sprites/Sprite2/Area2D2/CollisionShape2D.disabled = true;
	$Sprites/Sprite3.self_modulate.a = 0;
	$Sprites/Sprite3/Area2D3/CollisionShape2D.disabled = true;