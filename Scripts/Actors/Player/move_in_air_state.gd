class_name MoveInAirState
extends PlayerState

export(bool) var jumped := false
export(bool) var transitioned := false

var cutoff := false
var land := false
var done_ascent := false
var done_descent := false
var wasnt_wall_R := false
var is_wall_R := false
var wasnt_wall_L := false
var is_wall_L := false

onready var ledge_cast_R = host.get_node("Utilities/LedgeCastR")
onready var ledge_cast_L = host.get_node("Utilities/LedgeCastL")
onready var ledge_box_R = host.get_node("Utilities/LedgeBoxR")
onready var ledge_box_L = host.get_node("Utilities/LedgeBoxL")


func _enter():
	host.move_state = 'move_in_air'

func _handle_animation():
	if(host.on_floor() && !land):
		land = true
		host.animate(host.base_anim, "Land", false)
	elif(!land):
		if((cutoff && !transitioned) || (host.vert_spd > -250 && !transitioned)):
			host.animate(host.base_anim,"AscendToDescend", false)
		elif((!done_ascent || !done_descent)):
			if(host.vert_spd < 0 && !done_ascent):
				host.animate(host.base_anim,"Ascend", false)
				done_ascent = true
				done_descent = false
			if(host.vert_spd > 0 && !done_descent):
				host.animate(host.base_anim,"Descend", false)
				done_descent = true
				done_ascent = false
	._handle_animation()

func _handle_input():
	if(jumped && !Input.is_action_pressed("jump") && host.vert_spd < 0):
		
		cutoff = true
		host.vert_spd += 60
	._handle_input()

func exit_ledge(ledge_cast, wasnt_wall, is_wall, ledge_box, dir):
	if(!ledge_cast.is_colliding()):
		wasnt_wall = true;
	if(wasnt_wall && ledge_cast.is_colliding()):
		is_wall = true;
	else:
		is_wall = false;
	if(wasnt_wall && is_wall && ledge_box.get_overlapping_bodies().size() == 0):
		ledge_grab_state.ledge_cast = ledge_cast;
		ledge_grab_state.ledge_box = ledge_box;
		ledge_grab_state.dir = dir;
		_exit(ledge_grab_state);
		return true
	return false

func _execute(delta):
	
	if(exit_ledge(ledge_cast_R, wasnt_wall_R, is_wall_R, ledge_box_R, 1)):
		return
	if(exit_ledge(ledge_cast_L, ledge_cast_L, is_wall_L, ledge_box_L, -1)):
		return
	
	._execute(delta)


func _exit(state):
	jumped = false
	transitioned = false
	cutoff = false
	land = false
	done_ascent = false
	done_descent = false
	wasnt_wall_R = false
	is_wall_R = false
	wasnt_wall_L = false
	is_wall_L = false
	._exit(state)
