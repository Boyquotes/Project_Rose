class_name Player
extends Actor
# desc
# long desc

signal hp_changed
signal mana_changed
signal focus_changed

# TODO: move to globals perhaps
enum InputType {GAMEPAD, KEYMOUSE}
var active_input = InputType.GAMEPAD

var targettable_hitboxes := []
var rad := 0.0
var deg := 0.0
var move_state := "move_on_ground"

onready var AttackCollision = $AttackCollision
###states###
onready var move_states = {
	'move_on_ground' : $Movement_States/Move_On_Ground,
	'move_in_air' : $Movement_States/Move_In_Air,
	'ledge_grab' : $Movement_States/Ledge_Grab,
	'attack' : $Movement_States/Attack,
	'hurt' : $Movement_States/Hurt,
	'vortex' : $Movement_States/Vortex,
	'charge' : $Movement_States/Charge,
	'homing' : $Movement_States/Homing
	}
onready var CamNode = $Camera


#sets up some variables and initializes the state machine
func _ready():
	._ready()
	$Camera2D.current = true
	move_states[move_state].enter()
	$PhysicsCollider.disabled = false
	$HitArea/Hitbox.disabled = false


#hotswitch between keyboard and controller input
#should be able to expand this to detect different types of controllers
func _input(event):
	if(event.get_class() == "InputEventMouseButton" || event.get_class() == "InputEventKey" || Input.get_connected_joypads().size() == 0):
		active_input = InputType.KEYMOUSE
	elif(event.get_class() == "InputEventJoypadMotion" || event.get_class() == "InputEventJoypadButton"):
		active_input = InputType.GAMEPAD


#runs every frame
#home to debug inputs
#calculates the player's input rotation for aiming abilities
#also runs player hitbox "sight" to determine if an attack can hit an enemy
func _execute(delta):
	### DEBUGGING, NEED TO REMOVE ###
	if(Input.is_action_just_pressed("soft_reset")):
		global_position = Vector2(0,0)
	if(Input.is_key_pressed(KEY_I)):
		move_states['hurt'].compare_to = global_position
		move_states[move_state].exit(move_states['hurt'])
	
	# rad = $Target.execute(delta)
	# deg = rad2deg(rad)
	# $Target.global_rotation_degrees = deg


#moves the player and runs state logic
func _phys_execute(delta):
	if(get_tree().paused):
		_paused_phys_execute(delta)
	else:
		_unpaused_phys_execute(delta)


func _unpaused_phys_execute(delta):
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
	if(on_floor()):
		air_time = 0
		vel.y = 0
		vert_spd = 0
	
	if(is_on_ceiling()):
		vert_spd = 0
	
	if(grav_activated):
		vert_spd += true_grav
	
	#cap grav
	if(vert_spd > grav_max && grav_activated) :
		vert_spd = grav_max


func _paused_phys_execute(delta):
	move_states[move_state]._paused_handle_input()
	move_states[move_state]._pausedHandle_animation()
	move_states[move_state]._paused_execute(delta)


#cleans up attack instancing
func _cleanup():
	pass
	#$Movement_States/Attack/Attack_Controller/Attack_Instancing.clear()


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
	if(active_input == InputType.KEYMOUSE):
		return (deg > -60 && deg < 60)
	else:
		return false


func mouse_u() -> bool:
	if(active_input == InputType.KEYMOUSE):
		return (deg > -150 && deg < -30)
	else:
		return false


func mouse_l() -> bool:
	if(active_input == InputType.KEYMOUSE):
		return (deg > 120 || deg < -120)
	else:
		return false


func mouse_d() -> bool:
	if(active_input == InputType.KEYMOUSE):
		return (deg < 150 && deg > 30)
	else:
		return false


#activates fric to deccelerate the player
func activate_fric():
	.activate_fric()


#activates grav to pull the player down
func activate_grav():
	.activate_grav()


#deactivates fric for abilities where grav is inconvenient
func deativate_fric():
	.deactivate_fric()


#deactivates grav for abilities where grav is inconvenient
func deactivate_grav():
	.deactivate_grav()


#Temporarily change grav for the convenience of some abilities.
func change_grav(g):
	true_grav = g


#Temporarily change fric for the convenience of some abilities.
func change_fric(f):
	true_fric = f


#useful for easily adding or subtracting vel to an ability through animation
func add_vel(speed : float, degrees : float = $Movement_States/Attack/Attack_Controller.attack_degrees):
	hor_spd = speed * cos(deg2rad(degrees))
	vert_spd = speed * sin(deg2rad(degrees))


#useful for having the player jump from any state
func jump():
	vert_spd = -true_jump_spd


#useful for easily changing states without having a lot of local references
func change_move_state(var state: NodePath):
	move_states[move_state].exit(get_node(state))


#convenient for changing the player's health, whether it is a heal or damage
func change_hp(health):
	hp += health
	if(hp > max_hp):
		hp = max_hp
	emit_signal("hp_changed",hp)


#Death trigger
func _on_Player_System_hit_zero():
	enabled = false
	get_tree().change_scene("res://Scenes/Test_Scene.tscn")
	#$TopAnim.play("death")


#trigger for updating powerup flags
func _on_UpgradeMenu_update_powerup(idx,activate):
	$Powerups.powerups_idx[idx] = activate


#animates the animator with a new animation anim
func animate(animator, anim, cont = true):
	.animate(animator, anim, cont)

