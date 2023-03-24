class_name MoveInAirState
extends PlayerState

@export var jumped := false
@export var transitioned := false
@export var jump := false
@export var ledge_cast_l_path: NodePath
@export var ledge_cast_r_path: NodePath
@export var open_ledge_cast_l_path: NodePath
@export var open_ledge_cast_r_path: NodePath
@export var max_jump_charges := 0
@export var jump_charge := 0

var cutoff := false
var land := false
var done_ascent := false
var done_descent := false
var wasnt_wall_r := false
var is_wall_r := false
var wasnt_wall_l := false
var is_wall_l := false
var ledge_cast_l
var ledge_cast_r
var open_ledge_cast_l
var open_ledge_cast_r

@onready var ledge_disable_timer = $LedgeDisableTimer

func init():
	super.init()
	ledge_cast_r = get_node(ledge_cast_r_path)
	ledge_cast_l = get_node(ledge_cast_l_path)
	open_ledge_cast_r = get_node(open_ledge_cast_r_path)
	open_ledge_cast_l = get_node(open_ledge_cast_l_path)
	
func _ready():
	jumped = false


func _enter():
	host.move_state = 'move_in_air'

func _handle_input():
	if jumped && !Input.is_action_pressed("Jump") && host.vert_spd < 0:
		cutoff = true
		host.vert_spd += 60
	if Input.is_action_just_pressed("Jump") && jump_charge > 0 && host.vert_spd >= 0:
		jump_charge -= 1
		jump = true
	super._handle_input()

func _handle_animation():
	if(jump):
		host.animate(host.base_anim, "AirJump", false);
	else:
		if host.is_on_floor() && !land:
			land = true
			host.animate(host.base_anim, "Land", false)
		elif !land:
			if not transitioned and (cutoff or host.vert_spd > -250):
				host.animate(host.base_anim,"AscendToDescend", false)
			else:
				if host.vert_spd < 0:
					host.animate(host.base_anim, "Ascend", false)
				if host.vert_spd > 0:
					host.animate(host.base_anim, "Descend", false)
	super._handle_animation()


func _execute(delta):
	if host.vert_spd >= 0:
		if detect_ledge(ledge_cast_r, open_ledge_cast_r, 1):
			return
		if detect_ledge(ledge_cast_l, open_ledge_cast_l, -1):
			return
	
	super._execute(delta)


func _exit(state):
	jump = false
	jumped = false
	transitioned = false
	cutoff = false
	land = false
	done_ascent = false
	done_descent = false
	wasnt_wall_r = false
	is_wall_r = false
	wasnt_wall_l = false
	is_wall_l = false
	super._exit(state)

func detect_ledge(ledge_cast : RayCast2D, open_ledge_cast, dir : int):
	if ledge_cast.is_colliding() and not open_ledge_cast.is_colliding():
		FSM.ledge_grab_state.ledge_cast = ledge_cast
		FSM.ledge_grab_state.move_direction = dir
		_exit(FSM.ledge_grab_state)
		return true
	return false


func ledge_detection_switch():
	ledge_cast_r.enabled = !ledge_cast_r.enabled
	ledge_cast_l.enabled = !ledge_cast_l.enabled


func _on_LedgeDisableTimer_timeout():
	ledge_detection_switch()

func _on_animator_component_animation_finished(anim_name):
	if(anim_name == "AscendToDescend"):
		transitioned = true;
