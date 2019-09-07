extends "res://Objects/Actors/Enemies/Enemy_State.gd"

func enter():
	host.state = 'backoff';
	$backoffTimer.start();

func handleAnimation():
	host.animate(host.get_node("animator"),"backoff", false);

func execute(delta):
	host.hspd = 250 * -host.Direction;

func _on_backoffTimer_timeout():
	exit(default);
