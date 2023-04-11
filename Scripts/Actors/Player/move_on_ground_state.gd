class_name MoveOnGroundState
extends PlayerState

@export var look_max := 100
@onready var look_timer : Timer = $LookTimer
@export var open_cast_l_path : NodePath
@export var open_cast_r_path : NodePath

var open_cast_l : RayCast2D
var open_cast_r : RayCast2D
var jump := false
var crouch := false
var look_up := false
var slide := false
var looking := false
var force_crouch := false

func _ready():
	open_cast_l = get_node(open_cast_l_path)
	open_cast_r = get_node(open_cast_r_path)

func _enter():
	super._enter()
	host.move_state = 'move_on_ground'


func _handle_input():
	if super._handle_input():
		return
	if ((Input.is_action_pressed("Move_Down") or Input.is_action_pressed("Aim_Down"))
			and move_direction == 0
			and not slide):
		crouch = true
	
	if ((Input.is_action_pressed("Move_Up") or Input.is_action_pressed("Aim_Up"))
			and move_direction == 0
			and not jump):
		look_up = true
		if not looking:
			looking = true
			look_timer.start()
	elif look_up:
		looking = false
		call_timeout()
		look_up = false
	
	if Input.is_action_just_pressed("Jump"):
		if  (abs(host.hor_spd) > 0
				and (Input.is_action_pressed("Aim_Down") or Input.is_action_pressed("Move_Down"))):
			slide = true
		else:
			jump = true
	move_direction = get_move_direction()
	if can_turn:
		update_look_direction_and_scale(move_direction)
	if slide:
		detect_block()
	else:
		force_crouch = false
	if not force_crouch:
		handle_action()

func _handle_animation():
	if super._handle_animation():
		return
	if jump:
		host.animate(host.base_anim, "Jump", false)
	else:
		if look_up:
			host.animate(host.base_anim, "LookUp", false)
		elif move_direction != 0 and not host.is_on_wall():
			host.animate(host.base_anim, "Run", false)
		else:
			host.animate(host.base_anim, "Idle", false)

func _execute(delta):
	if super._execute(delta):
		return
	if not host.is_on_floor():
		exit_air()
	if crouch or slide:
		_exit(FSM.crouch_state)


func _exit(state):
	if state == FSM.crouch_state and slide:
		state.slide = true;
	crouch = false
	slide = false
	look_up = false
	jump = false
	looking = false
	force_crouch = false
	call_timeout()
	super._exit(state)

func detect_block():
	force_crouch = open_cast_l.is_colliding() or open_cast_r.is_colliding()

func call_timeout():
	_on_look_timer_timeout()

func _on_look_timer_timeout():
	for cam in host.cams:
		cam.adj_position.y = 0
		
		if look_up:
			if looking:
				cam.adj_position.y = -look_max * 1.5
		if crouch:
			if looking:
				cam.adj_position.y = look_max
			else:
				cam.adj_position.y = -look_max / 2.0
