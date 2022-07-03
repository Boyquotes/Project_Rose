class_name Player
extends Actor
# desc
# long desc

signal hurt
signal hp_changed
signal flora_changed
signal focus_changed
signal resource_3_changed
signal item_changed

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


export (int) var max_flora := 10
export (int) var max_focus := 3
var flora := 0
var focus := 0

var rad := 0.0
var deg := 0.0
var move_state := "move_on_ground"
var speed_mag

onready var attack_collision = $Utilities/AttackCollision
onready var player_camera = $PlayerCamera

#sets up some variables and initializes the state machine
func init():
	.init()
	flora = max_flora
	focus = max_focus
	for key in move_states.keys():
		move_states[key] = get_node(move_states[key])
	if not Engine.editor_hint:
		player_camera = true
		$CollisionBox.disabled = false
		$HitArea/HitBox.disabled = false
	iframe = false


# This should be moved to some UI layer.
signal input_unstable
var switch_count := 0

#hotswitch between keyboard and controller input
#should be able to expand this to detect different types of controllers
func _in(event):
	if(event.get_class() == "InputEventMouseButton"
			or event.get_class() == "InputEventKey"
			or Input.get_connected_joypads().size() == 0):
		active_input = InputType.KEYMOUSE
		switch_count += 1
	elif(event.get_class() == "InputEventJoypadMotion"
			or event.get_class() == "InputEventJoypadButton"):
		active_input = InputType.GAMEPAD
		switch_count += 1
	
	if switch_count > 10:
		emit_signal("input_unstable")


#runs every frame
#home to debug inputs
#calculates the player's input rotation for aiming abilities
#also runs player hitbox "sight" to determine if an attack can hit an enemy
func _execute(_delta):
	if Input.is_key_pressed(KEY_I) && iframes <= 0:
		move_states['hit'].compare_to = global_position + Vector2(hor_dir * 25,0)
		move_states[move_state]._exit(move_states['hit'])
	
	rad = $Utilities/ActionTarget.execute(_delta)
	
	deg = rad2deg(rad)
	$Utilities/ActionTarget.global_rotation_degrees = deg



func _unpaused_phys_execute(delta):
	._unpaused_phys_execute(delta)
	#state machine
	move_states[move_state]._handle_input()
	move_states[move_state]._handle_animation()
	move_states[move_state]._execute(delta)
	#count time in air
	air_time += delta
	#move across surfaces
	vel.y = vert_spd
	vel.x = hor_spd
	vel = move_and_slide(vel, floor_normal)
	#no grav acceleration when on floor
	if is_on_floor():
		air_time = 0
		vel.y = 0
		vert_spd = 0
	
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


"""
#trigger for detecting a hitbox entering player sight zone
func _on_detect_DetectOtherArea_area_entered(area):
	if(!targettable_hitboxes.has(area)):
		targettable_hitboxes.push_back(area)
#trigger for detecting a hitbox leaving player sight zone
func _on_detect_DetectOtherArea_area_exited(area):
	if(targettable_hitboxes.has(area)):
		targettable_hitboxes.erase(area)
"""

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
	hor_spd = speed * cos(deg2rad(degrees))
	vert_spd = speed * sin(deg2rad(degrees))


#useful for having the player jump from any state
func jump(fact := 1.0):
	vert_spd = -true_jump_spd * fact
	if(vel.x == 0.0):
		vert_spd -= 10


func tween_global_position(new: Vector2, time: float = .1):
	new.x = new.x * hor_dir;
	new = global_position + new;
	$Utilities/Tween.interpolate_property(self,"global_position",global_position,new,time,Tween.TRANS_LINEAR,Tween.EASE_OUT)
	$Utilities/Tween.start();


#useful for easily changing states without having a lot of local references
func change_move_state(var state: NodePath):
	move_states[move_state].exit(get_node(state))

func hurt():
	change_hp(0)

#convenient for changing the player's health, whether it is a heal or damage
func change_hp(health):
	hp += health
	if hp > max_hp:
		hp = max_hp
	emit_signal("hp_changed", hp)

func change_flora(flora):
	flora += flora
	if flora > max_flora:
		flora = max_flora
	emit_signal("flora_changed", flora)

func change_focus(focus):
	focus += focus
	if focus > max_focus:
		focus = max_focus
	emit_signal("focus_changed", focus)

#Death trigger
func _on_Player_System_hit_zero():
	enabled = false
	#save game
	#move to death state
	SceneController.change_scene("res://Scenes/Test_Scene.tscn")


#trigger for updating powerup flags
func _on_UpgradeMenu_update_powerup(idx,activate):
	pass #powerups.powerups_idx[idx] = activate
