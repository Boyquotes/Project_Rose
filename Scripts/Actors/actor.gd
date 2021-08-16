class_name Actor
extends KinematicBody2D
# desc
# long_desc

###actor_exoport_data###
export(String) var tag = "NPC" # TODO: Make into enum in global context
export(int) var max_hp := 100
export(float) var base_soft_speed_cap := 100.0
export(float) var base_jump_spd := 50.0
export(int) var attack_damage := 5
export(bool) var enabled := true
##physics_export_vars###
export(float) var base_grav := 10.0
export(float) var base_fric := 50.0
export(float) var grav_max := 250.0
export(float) var base_acceleration := 30.0
export(Dictionary) var move_states := {}
export(bool) var iframe := false

###actor_data###
var hp: float 
var iframes := 0

###physics vars###
var air_time := 0.0
var hor_spd := 0.0
var vert_spd := 0.0
# 1 = left, -1 = right
var hor_dir := 1
var vel := Vector2(0, 0)
var grav_max_temp : float
var true_acceleration : float
var true_soft_speed_cap : float
var true_jump_spd : float
var true_fric : float
var true_grav : float
var floor_normal := Vector2(0, -1)
var grav_activated := true
var fric_activated := true

onready var base_anim = $Animators/BaseAnimator
onready var hit_box = $HitArea/HitBox

func _ready():
	init()

func init():
	true_grav = base_grav
	grav_max_temp = grav_max
	true_fric = base_fric
	true_soft_speed_cap = base_soft_speed_cap
	true_jump_spd = base_jump_spd
	true_acceleration = base_acceleration
	hp = max_hp
	### default movement controller vars ###
	#1 = right, -1 = left
	hor_dir = 1
	vel = Vector2(0, 0)
	floor_normal = Vector2(0, -1)
	$CollisionBox.disabled = false
	call_init_in_children(self)


func _input(_event):
	if enabled:
		_in(_event)


func _process(_delta):
	if enabled:
		_execute(_delta)


func _physics_process(_delta):
	if enabled:
		_phys_execute(_delta)


func _in(_event):
	pass

func _execute(_delta):
	pass


#moves the player and runs state logic
func _phys_execute(_delta):
	if get_tree().paused:
		_paused_phys_execute(_delta)
	else:
		_unpaused_phys_execute(_delta)

func _paused_phys_execute(_delta):
	pass

func _unpaused_phys_execute(_delta):
	if(iframes > 0):
		iframes -= 1
		hit_box.disabled = true
	else:
		hit_box.disabled = false

func _cleanup():
	pass

func animate(animator, anim, cont = true):
	animator.stop(cont)
	animator.play(anim)


func kill():
	#TODO: death anims and effects
	queue_free()


func on_floor() -> bool:
	return test_move(transform, Vector2(0, 1))


func deactivate_grav():
	grav_activated = false
	vert_spd = 0
	vel.y = 0


func mitigate_grav():
	vert_spd = 0
	vel.y = 0
	true_grav = base_grav * .5


func normalize_grav():
	true_grav = base_grav


func deactivate_grav_dont_stop():
	grav_activated = false


func deactivate_fric():
	fric_activated = false


func activate_grav():
	grav_activated = true


func activate_fric():
	fric_activated = true


func add_vel(speed : float, degrees : float):
	hor_spd = speed * cos(deg2rad(degrees))
	vert_spd = speed * sin(deg2rad(degrees))


func iframe(frames : int):
	iframes = frames


func call_init_in_children(parent):
	for child in parent.get_children():
		if child.has_method("init"):
			child.init()
