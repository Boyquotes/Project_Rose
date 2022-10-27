class_name ActionHitboxContainer
extends Node2D

var item_trace := []
var valid_targets := []

var host
var action_controller
var action_instancer

func init():
	for hitbox in get_children():
		hitbox.area_entered.connect(_on_area_entered)

func _process(delta):
	execute(delta)

func execute(_delta):
	pass

func _physics_process(delta):
	phys_execute(delta)

func phys_execute(_delta):
	hitbox_loop()

#determines if a player can hit a hitbox
func hitbox_loop():
	for hitbox in get_children():
		var space_state = get_world_2d().direct_space_state
		for item in host.targettable_hitboxes:
			if next_ray(hitbox, item, space_state):
				valid_targets.append(item)

#the logic to determine if a specific hitbox can be hit
func next_ray(origin, dest, spc):
	if !item_trace.has(origin):
		item_trace.push_back(origin)
	var result = spc.intersect_ray(origin.global_position,
			dest.global_position, item_trace, host.attack_coll_data.collision_mask)
	#if there is nothing between this attack and the destination, the item is hittable
	if result.is_empty():
		item_trace.clear()
		return true
	elif "attack_type" in result.collider:
		#if the attack type of a collider between this attack and the destination is the same
			#attack type as this attack, the attack pierces the collider.
		if result.collider.attack_type == origin.attack_type:
			#if the current result collider is not the destination, keep looking.
			if result.collider != dest:
				return next_ray(result.collider, dest, spc)
			#else the item is hittable
			else:
				item_trace.clear()
				return true
		#if the attack type of a collider between this attack and the destination is a
			#different attack type than this attack, the attack stops at the current result.
		else:
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
		item_trace.clear()
		return false

func _on_area_entered(hitbox):
	#hitbox = hitbox[0]
	#if other in valid_targets and not other.disabled:
	#	other.hits += 1
	#	if other.hits >= other.hit_limit and other.hit_limit > 0:
	#		other.disabled = true
	#	action_controller.on_hit(other, hitbox)
	#	other.on_hit(hitbox)
	pass
