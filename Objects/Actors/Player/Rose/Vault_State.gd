extends "./State.gd"

var vaulted = false;
var vaulting = false;
var distance_traversable = 50;
var displacement = 0
var hor = false;
var pos

func enter():
	host.state = 'vault';
	vaulting = true;
	pos = host.position
	if(!host.get_node("vault_cast").is_colliding()):
		exit_g_or_a();
	pass

func handleAnimation():
	pass;

func handleInput(event):
	if(event.is_action_just_pressed("jump")):
		host.vspd = -host.jspd;
		exit('move_in_air');
	pass

func execute(delta):
	if(host.get_node("vault_cast").is_colliding()):
		if(hor):
			host.position.y -= 3 * sign(host.get_node("vault_cast").cast_to.x);
		host.position.y -= 3 * sign(host.get_node("vault_cast").cast_to.y);
	else:
		vaulted = true;
	
	
	if(host.position.x > pos.x):
		displacement += host.position.x - pos.x;
		pos.x = host.position.x; 
	elif(host.position.x < pos.x):
		displacement += pos.x - host.position.x;
		pos.x = host.position.x;
	if(abs(displacement) < distance_traversable):
		if(host.on_floor()):
			host.hspd = 0;
		elif(host.hspd > 0 || host.hspd < 0):
			host.hspd -= 25*host.Direction;
	else:
		host.hspd = 0;
	
	if(!vaulted && !host.get_node("vault_cast").is_colliding()):
		exit_g_or_a();
	
	pass

func exit(state):
	vaulted = false;
	vaulting = false;
	hor = false;
	#distance_traversable = 60;
	displacement = 0
	pos = host.position
	.exit(state);
	pass
