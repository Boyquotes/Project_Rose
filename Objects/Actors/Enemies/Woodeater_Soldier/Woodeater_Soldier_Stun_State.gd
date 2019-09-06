extends "res://Objects/Actors/Enemies/Enemy_Stun_State.gd"

func handleAnimation():
	host.animate(host.get_node("animator"),"stun", false);

func _on_stunTimer_timeout():
	hurt.armor = [30,30,30,30];
	._on_stunTimer_timeout();
