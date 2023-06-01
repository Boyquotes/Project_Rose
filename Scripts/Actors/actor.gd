class_name Actor
extends CharacterBody2D
# desc
# long_desc

signal turned
signal animation_changed
signal landed

###actor_export_data###
@export var base_soft_speed_cap := 100.0
@export var base_jump_spd := 50.0
@export var attack_damage := 5
@export var enabled := true
##physics_export_vars###
@export var base_grav := 10.0
@export var base_fric := 50.0
@export var grav_max := 250.0
@export var base_acceleration := 30.0
@export var state_machine : FiniteStateMachine

var targettable_hitboxes := []

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
var prev_anim := ""

var base_anim : AnimationPlayer
var attack_coll_data : Area2D
var powerup_data : Node2D

func _ready():
	base_anim = $AnimatorComponent
	attack_coll_data = $Utilities/AttackCollision
	powerup_data = $Utilities/Powerups
	init()

func init():
	true_grav = base_grav
	grav_max_temp = grav_max
	true_fric = base_fric
	true_soft_speed_cap = base_soft_speed_cap
	true_jump_spd = base_jump_spd
	true_acceleration = base_acceleration
	### default movement controller vars ###
	#1 = right, -1 = left
	hor_dir = 1
	vel = Vector2(0, 0)
	floor_normal = Vector2(0, -1)
	$CollisionBox.disabled = false
	call_init_in_children(self, self)


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
	pass

func _cleanup():
	pass

func animate(animator : AnimationPlayer, anim : String, cont = true):
	anim = "RoseAnimations/" + anim
	if prev_anim != anim:
		emit_signal("animation_changed", prev_anim, anim)
		prev_anim = anim
		animator.stop(cont)
	animator.play(anim)

func kill():
	#TODO: death anims and effects
	queue_free()


#func on_floor() -> bool:
#	return test_move(transform, Vector2(0, 1))


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
	hor_spd = speed * cos(deg_to_rad(degrees))
	vert_spd = speed * sin(deg_to_rad(degrees))

func has_powerup(powerup):
	return powerup_data.powerups[powerup]

func call_init_in_children(host, parent):
	for child in parent.get_children():
		if "host" in child:
			child.host = host
		if child.has_method("init"):
			child.init()
		host.call_init_in_children(host, child)
