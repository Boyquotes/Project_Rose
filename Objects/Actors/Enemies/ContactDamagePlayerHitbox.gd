extends "res://Objects/Actors/Enemies/DamagePlayerHitbox.gd"

func _ready():
	host = get_parent();
	print(host);
	comparison = host.global_position;
	print(comparison);
