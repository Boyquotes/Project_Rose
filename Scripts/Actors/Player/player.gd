class_name Player
extends Actor
# desc
# long desc

signal flora_changed
signal focus_changed
signal resource_3_changed
signal item_changed
signal footstep
signal sliding
signal silence

# TODO: move to globals perhaps
enum InputType {GAMEPAD, KEYMOUSE}
enum Styles {BASE, WIND, EARTH, THUNDER}

var active_input = InputType.GAMEPAD
var style_states := {
	Styles.BASE : "Base",
	Styles.WIND : "Wind",
	Styles.EARTH : "Earth",
	Styles.THUNDER : "Thunder"
}
var style_state = Styles.BASE


@export var max_flora := 10
@export var max_focus := 3
var flora := 0
var focus := 0

var rad := 0.0
var deg := 0.0
var move_state := "move_on_ground"
var speed_mag
var was_on_floor := false
@onready var attack_collision = $Utilities/AttackCollision
@onready var cams : Array[PlayerCamera2D] = []
@onready var powerups = $Utilities/Powerups
@onready var collision_box = $CollisionBox
@onready var crouch_box = $CrouchBox
@onready var hitbox = $HitBoxComponent
@onready var crouch_hitbox = $CrouchHitBoxComponent
@onready var FSM = $MoveStates

#sets up some variables and initializes the state machine

func init():
	super.init()
	flora = max_flora
	focus = max_focus
	for key in move_states.keys():
		move_states[key] = get_node(move_states[key])
	if not Engine.is_editor_hint():
		$CollisionBox.disabled = false
	crouch_box.disabled = true
	collision_box.disabled = false
	emit_signal("ready")


# This should be moved to some UI layer.
signal input_unstable
var switch_count := 0

#hotswitch between keyboard and controller input
#should be able to expand this to detect different types of controllers
func _in(_event):
	if active_input != InputType.KEYMOUSE and Input.get_connected_joypads().size() == 0:
		active_input = InputType.KEYMOUSE
	elif active_input != InputType.GAMEPAD:
		active_input = InputType.GAMEPAD


#runs every frame
#home to debug inputs
#calculates the player's input rotation for aiming abilities
func _execute(_delta):
	if Input.is_key_pressed(KEY_I):
		move_states['hit'].compare_to = global_position + Vector2(hor_dir * 25,0)
		move_states[move_state]._exit(move_states['hit'])
	
	rad = $Utilities/TargetReticle.execute(_delta)
	
	deg = rad_to_deg(rad)
	$Utilities/TargetReticle.global_rotation = rad



func _unpaused_phys_execute(delta):
	super._unpaused_phys_execute(delta)
	#state machine
	move_states[move_state]._handle_input()
	move_states[move_state]._handle_animation()
	move_states[move_state]._execute(delta)
	#count time in air
	air_time += delta
	#move across surfaces
	vel.y = vert_spd
	vel.x = hor_spd
	set_velocity(vel)
	set_up_direction(floor_normal)
	move_and_slide()
	vel = velocity
	#no grav acceleration when checked floor
	if is_on_floor():
		if not was_on_floor:
			emit_signal("landed")
		air_time = 0
		vel.y = 0
		vert_spd = 0
		was_on_floor = true
	else:
		was_on_floor = false
	
	if is_on_ceiling():
		vert_spd = 0
	
	if grav_activated:
		vert_spd += true_grav
	
	#cap grav
	if vert_spd > grav_max && grav_activated:
		vert_spd = grav_max
	
	if vert_spd >= 150 and not done:
		done = true
		get_node("Utilities/CapeTarget").scale.x *= -1
	if vert_spd < 150 and done:
		done = false
		get_node("Utilities/CapeTarget").scale.x *= -1

var done = false

func _paused_phys_execute(delta):
	move_states[move_state]._paused_handle_input()
	move_states[move_state]._paused_handle_animation()
	move_states[move_state]._paused_execute(delta)


##trigger for detecting a hitbox entering player sight zone
#func _on_detect_DetectOtherArea_area_entered(area):
#	if(!targettable_hitboxes.has(area)):
#		targettable_hitboxes.push_back(area)
##trigger for detecting a hitbox leaving player sight zone
#func _on_detect_DetectOtherArea_area_exited(area):
#	if(targettable_hitboxes.has(area)):
#		targettable_hitboxes.erase(area)


#useful for easily getting the general hor_dir of the mouse
func mouse_r() -> bool:
	if active_input == InputType.KEYMOUSE:
		return (deg > -60 && deg < 60)
	else:
		return false


func mouse_u() -> bool:
	if active_input == InputType.KEYMOUSE:
		return (deg > -150 && deg < -30)
	else:
		return false


func mouse_l() -> bool:
	if active_input == InputType.KEYMOUSE:
		return (deg > 120 || deg < -120)
	else:
		return false


func mouse_d() -> bool:
	if active_input == InputType.KEYMOUSE:
		return (deg < 150 && deg > 30)
	else:
		return false


#Temporarily change grav for the convenience of some abilities.
func change_grav(g):
	true_grav = g


#Temporarily change friction for the convenience of some abilities.
func change_fric(f):
	true_fric = f


#useful for easily adding or subtracting vel to an or effect ability through animation
func add_vel(speed : float, degrees : float = $MoveStates/Action/ActionController.action_degrees):
	hor_spd = speed * cos(deg_to_rad(degrees))
	vert_spd = speed * sin(deg_to_rad(degrees))

func add_vel_hor(speed : float):
	hor_spd = speed * move_states[move_state].move_direction#hor_dir

func slide(fact := 1.0):
	hor_spd = true_soft_speed_cap * fact * hor_dir


#useful for having the player jump from any state
func jump(fact := 1.0):
	vert_spd = -true_jump_spd * fact
	if(vel.x == 0.0):
		vert_spd -= 10


func tween_global_position(new: Vector2, time: float = .1):
	new.x = new.x * hor_dir;
	new = global_position + new;
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_LINEAR)
	tween.tween_property(self, "global_position", new, time)

func change_to_grounded_anim(animator : AnimationPlayer, last_queued_action):
	var frame = animator.current_animation_position + 0.0
	if is_instance_valid(last_queued_action) and frame <= .1:
		frame = .11
	var anim = animator.current_animation
	var grounded_anim = ""
	if "_Air" in anim:
		var air_idx = anim.find("_Air")
		grounded_anim = anim.substr(0, air_idx) + anim.substr(air_idx + 4)
	if "_Down" in grounded_anim:
		var down_idx = grounded_anim.find("_Down")
		grounded_anim = grounded_anim.substr(0, down_idx) + grounded_anim.substr(down_idx + 5)
	if frame > 0.1:
		grounded_anim += "_Grounded"
	if animator.has_animation("RoseAnimations/" + grounded_anim):
		#animator.stop(false)
		animator.play(grounded_anim)
		animator.seek(frame, true)

#useful for easily changing states without having a lot of local references
func change_move_state(state: NodePath):
	move_states[move_state].exit(get_node(state))

func change_flora(flora_in):
	flora += flora_in
	if flora > max_flora:
		flora = max_flora
	emit_signal("flora_changed", flora)

func change_focus(focus_in):
	focus += focus_in
	if focus > max_focus:
		focus = max_focus
	emit_signal("focus_changed", focus)

#Death trigger
func _on_Player_System_hit_zero():
	enabled = false
	#save game
	#move to death state
	SceneController.change_scene_to_file("res://Scenes/Test_Scene.tscn")


#trigger for updating powerup flags
func _on_UpgradeMenu_update_powerup(idx,activate):
	powerups.powerups_idx[idx] = activate


func attach_cam(cam : PlayerCamera2D):
	cams.push_back(cam)
	cam.global_position = global_position
	cam.reset_smoothing()
	cam.align()
	

func save_data():
	var save_dict = {
		"pos_x" : position.x,
		"pos_y" : position.y
	}
	return save_dict

func load_data(data):
	position = Vector2(data["pos_x"], data["pos_y"])

func _on_animator_component_animation_finished(anim_name):
	if anim_name == "RoseAnimations/Slide":
		activate_fric()
		FSM.crouch_state.slide = false

func _on_rose_animation_changed(prev_anim, new_anim):
	if prev_anim == "RoseAnimations/Slide":
		activate_fric()
		FSM.crouch_state.slide = false
		emit_signal("silence")
	if prev_anim == "RoseAnimations/Run" and new_anim == "RoseAnimations/Idle":
		emit_signal("footstep", 3.0)
	if prev_anim == "RoseAnimations/Crouch" and new_anim == "RoseAnimations/Idle":
		emit_signal("footstep", 4.0)

