class_name CrouchState
extends PlayerState

@export var look_max := 100
@export var open_cast_l_path : NodePath
@export var open_cast_r_path : NodePath

@onready var look_timer : Timer = $LookTimer

var open_cast_l : RayCast2D
var open_cast_r : RayCast2D
var jump := false
var look_down := false
var look_up := false
var looking := false
var force_crouch := false
var stand := false

func init():
	open_cast_l = get_node(open_cast_l_path)
	open_cast_r = get_node(open_cast_r_path)
	super.init()

func _enter():
	host.true_soft_speed_cap /= 2
	host.crouch_hitbox.disabled = false
	host.crouch_box.disabled = false
	host.hitbox.disabled = true
	host.collision_box.disabled = true
	host.move_state = 'crouch'


func _handle_input():
	detect_block()
	if ((Input.is_action_pressed("Move_Down") or Input.is_action_pressed("Aim_Down"))
			and move_direction == 0):
		look_down = true
		if not looking:
			if (Input.get_joy_axis(0,JOY_AXIS_LEFT_Y) > .5
					or Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y) > .5):
				looking = true
				look_timer.start(.25)
	elif look_down:
		looking = false
		call_timeout()
		look_down = false
	
	if ((Input.is_action_pressed("Move_Up") or Input.is_action_pressed("Aim_Up"))
			and move_direction == 0):
		if not force_crouch:
			stand = true
		else:
			look_up = true
			if not looking:
				if (Input.get_joy_axis(0,JOY_AXIS_LEFT_Y) < -.5
						or Input.get_joy_axis(0,JOY_AXIS_RIGHT_Y) < -.5):
					looking = true
					look_timer.start(.25)
	elif look_up:
		looking = false
		call_timeout()
		look_up = false
		
	move_direction = get_move_direction()
	
	if Input.is_action_just_pressed("Jump") and not force_crouch:
		jump = true
		move_direction = get_move_direction()
	
	if can_turn:
		update_look_direction_and_scale(move_direction)
	if (host.move_state != 'action' || host.move_state != 'hit') and not force_crouch:
		if get_action_just_pressed():
			_exit(FSM.action_state)
		elif get_switch_pressed():
			if Input.is_action_just_pressed("Switch_Bash") and host.has_powerup(GlobalEnums.Powerups.METEOR_STYLE):
				switch_bash = true
			elif Input.is_action_just_pressed("Switch_Pierce") and host.has_powerup(GlobalEnums.Powerups.VOLT_STYLE):
				switch_pierce = true
			elif Input.is_action_just_pressed("Switch_Slash") and host.has_powerup(GlobalEnums.Powerups.VORTEX_STYLE):
				switch_slash = true


func _handle_animation():
	if jump:
		host.animate(host.base_anim, "Jump", false)
	else:
		if move_direction != 0:
			host.animate(host.base_anim, "Crawl", false)
		else:
			host.animate(host.base_anim, "Crouch", false)
	super._handle_animation()


func _execute(delta):
	super._execute(delta)
	if not host.is_on_floor():
		exit_air()
	if stand:
		exit_ground()


func detect_block():
	if open_cast_l.is_colliding() or open_cast_r.is_colliding():
		force_crouch = true
	else:
		force_crouch = false

func _exit(state):
	jump = false
	look_down = false
	look_up = false
	looking = false
	force_crouch = false
	stand = false
	host.true_soft_speed_cap = host.base_soft_speed_cap
	host.crouch_hitbox.disabled = true
	host.crouch_box.disabled = true
	host.hitbox.disabled = false
	host.collision_box.disabled = false
	if state == FSM.action_state:
		state.action_controller.crouched = true
	super._exit(state)

func call_timeout():
	_on_look_timer_timeout()

func _on_look_timer_timeout():
	host.player_camera.position.y = 0
	
	if look_up:
		if looking:
			host.player_camera.position.y = -look_max * 1.5
	if look_down:
		if looking:
			host.player_camera.position.y = look_max
		else:
			host.player_camera.position.y = -look_max / 2.0
