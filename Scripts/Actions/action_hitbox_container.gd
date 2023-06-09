class_name ActionHitboxContainer
extends Node2D

@export var action : CharacterAction

var item_trace := []
var valid_targets := []

var host : Player
var action_controller
var action_instancer

func _process(delta):
	execute(delta)

func execute(_delta):
	pass

func _physics_process(delta):
	phys_execute(delta)

func phys_execute(_delta):
	hitbox_loop()
	print(valid_targets)

#determines if a player can hit a hitbox
func hitbox_loop():
	for hitbox in get_children():
		var space_state := get_world_2d().direct_space_state
		for item in host.targettable_hitboxes:
			if next_ray(hitbox, item, space_state):
				if not valid_targets.has(item):
					valid_targets.append(item)

#the logic to determine if a specific hitbox can be hit
func next_ray(origin, dest, spc : PhysicsDirectSpaceState2D):
	if !item_trace.has(origin):
		item_trace.push_back(origin)
	print(origin.global_position, " ", dest.global_position)
	var params := PhysicsRayQueryParameters2D.create(origin.global_position,
			dest.global_position, host.attack_coll_data.collision_mask, item_trace)
	params.collide_with_areas = true
	params.collide_with_bodies = false
	var result := spc.intersect_ray(params)
	#if there is nothing between this attack and the destination, the item is hittable
	if result.is_empty():
		item_trace.clear()
		return true
	#if the collider between this attack and the destination is a blocker or the attack is blockable,
		# the attack does not pierce the collider, otherwise it does.
	elif result.collider.blocker or action.blockable:
		#if the current result collider is not the destination, the attack is cut unchecked at
			#the result and the item is not hittable.
		if result.collider != dest:
			item_trace.clear()
			return false
		#else, the item is hittable
		else:
			item_trace.clear()
			return true
	else:
		#if the current result collider is not the destination, keep looking.
		if result.collider != dest:
			return next_ray(result.collider, dest, spc)
		#else the item is hittable
		else:
			item_trace.clear()
			return true
