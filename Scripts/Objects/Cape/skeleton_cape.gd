class_name SkeletonClothSim
extends Node2D

@export var phys_obj_path: NodePath
@export var targets_path: NodePath
@export var influencers_path: NodePath
@export var wind_path: NodePath
@export var skeleton_path: NodePath
@export var gravity := 480.0
@export var initial_rest_distance := 2.0
@export var active := true
@export var draw_cape := false
@export var cloth_height := 8
@export var cloth_width := 5

var wind_node
var influencers_node
var influencers : Dictionary
var phys_obj_node
var targets_node : Node2D
var skeleton_node
var physics : SkeletonClothPhysics
var pointmasses : Array
var targets : Array
var bones : Array
var top_cloth : Array

# every SkeletonPointMass within this many pixels will be influenced by the cursor
var mouse_influence_size := 5.0
# minimum distance for tearing when user is right clicking
var mouse_tear_size := 1.0
var mouse_influence_scalar := 50.0

var resting_distance := 0.0
var stiffnesses := .75
var tear_sensitivity := 500 # distance the PointMasss have to go before ripping

var mouse_position := Vector2()
var prev_mouse_position := Vector2()

func _ready():
	if active:
		global_position = Vector2.ZERO
		resting_distance = initial_rest_distance
		physics = SkeletonClothPhysics.new()
		physics.fixed_deltatime = 16
		physics.fixed_deltatime_seconds = float(physics.fixed_deltatime) / 1000.0
		physics.leftover_deltatime = 0
		physics.constraint_accuracy = 3
		
		mouse_influence_size *= mouse_influence_size 
		mouse_tear_size *= mouse_tear_size
		
		#mouse_position = get_local_mouse_position()
		#prev_mouse_position = Vector2(0, 0)
		
		phys_obj_node = get_node(phys_obj_path)
		
		influencers_node = get_node(influencers_path)
		for influencer in influencers_node.get_children():
			influencers[influencer] = influencer.global_position
		targets_node = get_node(targets_path)
		
		skeleton_node = get_node(skeleton_path).get_child(0)
		wind_node = get_node(wind_path)
		create_cloth(targets_node.global_position, self)

func reassign_pins():
	var inv := []
	for target in targets:
		inv.push_front(target)
	for i in range(inv.size()):
		top_cloth[i].pin_to(inv[i])
	targets = inv

func get_bones(i : int, bone : Node):
	bones[i].push_back(bone)
	if bone.get_child_count() > 0:
		get_bones(i, bone.get_child(0))

func get_bone_length(bone : Node):
	if bone.get_child_count() > 0:
		return 1 + get_bone_length(bone.get_child(0))
	else:
		return 1

func create_cloth(cloth_position : Vector2, this : SkeletonClothSim):
	# mid_width: amount to translate the curtain along x-axis for it to be centered
	# (curtainWidth * restingDistances) = curtain's pixel width
	#var mid_width = int(width/2 - (curtainWidth * restingDistances)/2)
	for i in skeleton_node.get_child_count():
		bones.push_back([])
		get_bones(i, skeleton_node.get_child(i))
	
	# Since this our fabric is basically a grid of points, we have two loops
	for y in cloth_height: # due to the way PointMasss are attached, we need the y loop checked the outside
		pointmasses.push_back([])
		this.resting_distance += .25
		for x in cloth_width:
			var pointmass = SkeletonPointMass.new(cloth_position.x + x * this.resting_distance, cloth_position.y + y * this.resting_distance, x, y, this.resting_distance)
			# attach to 
			# x - 1  and
			# y - 1  
			#  *<---*<---*<-..
			#  ^    ^    ^
			#  |    |    |
			#  *<---*<---*<-..
			#
			# SkeletonPointMass attach_to parameters: SkeletonPointMass SkeletonPointMass, float restingDistance, float stiffness
			# try disabling the next 2 lines (the if statement and attach_to part) to create a hairy effect
			if x != 0:
				pointmass.attach_to(pointmasses[y][pointmasses[y].size()-1], this)
			# the index for the PointMasss are one dimensions, 
			# so we convert x,y coordinates to 1 dimension using the formula y*width+x  
			if y != 0:
				pointmass.attach_to(pointmasses[y-1][x], this)
				
			# we pin the very top PointMasss to where they are
			if y == 0:
				var target = targets_node.get_child(x)
				target.global_position = to_global(pointmass.pos)
				this.targets.push_back(target)
				this.top_cloth.push_back(pointmass)
				pointmass.pin_to(target)
			# add to SkeletonPointMass array  
			pointmasses[y].push_back(pointmass)

var deltatime := 0.0

func _physics_process(_delta):
	if active:
		global_position = Vector2.ZERO
		deltatime += _delta
		
		for i in cloth_width:
			#z-index has to work on polygons, not bonesa
			bones[i][0].z_index = targets[i].z_index
			
		
		
		physics.update(self, wind_node.wind, deltatime)
		
		

func flip_targets():
	targets.reverse()
	for i in cloth_width:
		pointmasses[0][i].pin_to(targets[i])

# Physics
# Timesteps are managed here
class SkeletonClothPhysics:
	var previous_time := 0.0
	var current_time := 0.0
	
	var fixed_deltatime := 0
	var fixed_deltatime_seconds := 0.0
	
	var leftover_deltatime := 0
	
	var constraint_accuracy := 5
	
	# Update physics
	func update(this : SkeletonClothSim, wind : Vector2, _time : float):
		# calculate elapsed time in ms
		current_time = Time.get_unix_time_from_system() * 1000
		var deltatime_ms = current_time - previous_time
		
		previous_time = current_time # reset previous time
		
		# break up the elapsed time into manageable chunks
		var time_step_amt = max(int(float(deltatime_ms + leftover_deltatime) / float(fixed_deltatime)), 1)
		
		# limit the time_step_amt to prevent potential freezing
		time_step_amt = min(time_step_amt, 5)
		
		# store however much time is leftover for the next frame
		leftover_deltatime = int(deltatime_ms) - (time_step_amt * fixed_deltatime)
		
		# How much to push PointMasses when the user is interacting
		this.mouse_influence_scalar = 1.0 / time_step_amt
		
		# update physics
		for itt in time_step_amt:
			# update each SkeletonPointMass's position
			for pointmass_arr in this.pointmasses:
				for pointmass in pointmass_arr:
					pointmass.update_interactions(this)
					pointmass.update_physics(fixed_deltatime_seconds, this, wind)
			# solve the constraints multiple times
			# the more it's solved, the more accurate.
			for x in constraint_accuracy:
				for pointmass_arr in this.pointmasses:
					for pointmass in pointmass_arr:
						pointmass.solve_constraints(this)
			for x in this.cloth_width:
				for y in this.cloth_height:
					if y != 0:
						this.bones[x][y-1].look_at(this.to_global(this.pointmasses[y][x].pos))
						this.bones[x][y-1].rotation -= PI/2
						var temp = this.to_global(this.pointmasses[y][x].pos) - this.bones[x][y].global_position
						this.bones[x][y].global_position += temp
					else:
						this.bones[x][y].global_position = this.to_global(this.pointmasses[y][x].pos)
		return

class SkeletonPointMass:
	# for calculating position change (velocity)
	var last_x := 0.0
	var last_y := 0.0
	var pos := Vector2()
	var acc_x := 0.0
	var acc_y := 0.0
	
	var xplace := 0
	var yplace := 0
	
	var mass := .5
	var damping := .91
	
	# An Array for links, so we can have as many links as we want to this SkeletonPointMass
	var links = []
	
	var pinned := false
	var pin : Node2D
	
	var resting_distance : float
	# SkeletonPointMass constructor
	func _init(x_pos : float,y_pos : float,x : int,y : int,rest : float):
		pos.x = x_pos
		pos.y = y_pos
		
		last_x = pos.x
		last_y = pos.y
		
		xplace = x
		yplace = y
		
		resting_distance = rest

	# The update function is used to update the physics of the SkeletonPointMass.
	# motion is applied, and links are drawn here
	# timeStep should be in elapsed seconds (deltaTime)
	func update_physics(timestep : float, this : SkeletonClothSim, wind : Vector2):
		apply_force(mass * wind.y + mass * this.gravity + mass * -this.phys_obj_node.vel.y, mass * wind.x + mass * -this.phys_obj_node.vel.x)
		
		var vel_x = pos.x - last_x
		var vel_y = pos.y - last_y
		
		# dampen velocity
		vel_x *= damping
		vel_y *= damping
		
		var timestep_sq = timestep * timestep
		
		# calculate the next position using Verlet Integration
		var next_x = pos.x + vel_x + 0.5 * acc_x * timestep_sq
		var next_y = pos.y + vel_y + 0.5 * acc_y * timestep_sq
		
		# reset variables
		last_x = pos.x
		last_y = pos.y
		
		pos.x = next_x
		pos.y = next_y
		
		acc_x = 0
		acc_y = 0
	
	func update_interactions(this : SkeletonClothSim):
		# this is where our interaction comes in.
		for influencer in this.influencers_node.get_children():
			if influencer.visible:
				var inf_pos = this.to_local(influencer.global_position)
				var inf_prev_pos = this.to_local(this.influencers[influencer])
				var distance_squared = dist_line_to_point_sq(inf_prev_pos, inf_pos, pos)
				if distance_squared < this.mouse_influence_size:
					print("!!!")
					# remember mouseInfluenceSize was squared in setup()
					# To change the velocity of our SkeletonPointMass, we subtract that change from the lastPosition.
					# When the physics gets integrated (see updatePhysics()), the change is calculated
					# Here, the velocity is set equal to the cursor's velocity
					print(last_x)
					last_x = pos.x + 1000#- (inf_pos.x - inf_prev_pos.x) * this.mouse_influence_scalar
					last_y = pos.y + 1000#- (inf_pos.y - inf_prev_pos.y) * this.mouse_influence_scalar
					print(last_x)
				else:  
					pass
				# if the right mouse button is clicking, we tear the cloth by removing links
					#if distance_squared < this.mouse_tear_size:
					#	links.clear()
				this.influencers[influencer] = influencer.global_position
	
	# Constraints 
	func solve_constraints(this : SkeletonClothSim):
		
		# SkeletonLink Constraints
		#    Links make sure PointMasss connected to this one is at a set distance away
		for link in links:
			link.solve()
	
		# Other Constraints
		var tempos = Vector2(pos.x, pos.y)
		var space_state : PhysicsDirectSpaceState2D = this.get_world_2d().direct_space_state
		var coll = 1
		var point_coll_params := PhysicsPointQueryParameters2D.new()
		point_coll_params.collision_mask = coll
		point_coll_params.position = tempos
		var collision_event = space_state.intersect_point(point_coll_params, 1)
		var intersecting = collision_event.size() > 0
		
		var dir = 0
		while(intersecting):
			intersecting = false
			dir += .01
			var params_up := point_coll_params
			params_up.position = Vector2(tempos.x,tempos.y-dir)
			var params_down := point_coll_params
			params_down.position = Vector2(tempos.x,tempos.y+dir)
			var params_left := point_coll_params
			params_left.position = Vector2(tempos.x-dir,tempos.y)
			var params_right := point_coll_params
			params_right.position = Vector2(tempos.x+dir,tempos.y)
			if space_state.intersect_point(params_up, 1).size() == 0:
				pos = Vector2(tempos.x,tempos.y-dir)
				intersecting = false
			elif space_state.intersect_point(params_down, 1).size() == 0:
				pos = Vector2(tempos.x,tempos.y+dir)
				intersecting = false
			elif space_state.intersect_point(params_left, 1).size() == 0:
				pos = Vector2(tempos.x-dir,tempos.y)
				intersecting = false
			elif space_state.intersect_point(params_right, 1).size() == 0:
				pos = Vector2(tempos.x+dir,tempos.y)
				intersecting = false
		
		# make sure the SkeletonPointMass stays in its place if it's pinned
		if pinned:
			pos = this.to_local(pin.global_position)
		
		
	# attach_to can be used to create links between this SkeletonPointMass and other PointMasss
	func attach_to(P : SkeletonPointMass, this : SkeletonClothSim):
		var link = SkeletonLink.new(self, P, this)
		links.push_back(link)
	
	func remove_link(link : SkeletonLink):
		links.erase(link)
	
	func pin_to(target : Node2D):
		pinned = true
		pin = target
	
	func apply_force(fy : float, fx : float):
		# acceleration = (1/mass) * force
		# or
		# acceleration = force / mass
		acc_x += fx / mass
		acc_y += fy / mass
	
	func dist_line_to_point_sq(line1 : Vector2, line2 : Vector2, point : Vector2):
		var vx = line1.x - point.x
		var vy = line1.y - point.y
		var ux = line2.x - line1.x
		var uy = line2.y - line1.y
		
		var length = ux * ux + uy * uy
		var det = (-vx * ux) + (-vy * uy)
		if det < 0 || det > length:
			ux = line2.x - point.x
			uy = line2.y - point.y
			return min(vx*vx+vy*vy, ux*ux+uy*uy)
		
		det = ux * vy - uy * vx
		return det * det / length

class SkeletonLink:
	var resting_distance := 0.0
	var stiffness := 0.0
	var tear_sensitivity := 0.0
	
	var p1 : SkeletonPointMass
	var p2 : SkeletonPointMass
	
	
	func _init(which1 : SkeletonPointMass,which2 : SkeletonPointMass,this : SkeletonClothSim):
		p1 = which1 # when you set one object to another, it's pretty much a reference. 
		p2 = which2 # Anything that'll happen to p1 or p2 in here will happen to the paticles in our ArrayList
		
		resting_distance = this.resting_distance
		stiffness = this.stiffnesses
		
		tear_sensitivity = this.tear_sensitivity
	
	# Solve the link constraint
	func solve():
		# calculate the distance between the two PointMasss
		var diffX = p1.pos.x - p2.pos.x
		var diffY = p1.pos.y - p2.pos.y
		var d = max(sqrt(diffX * diffX + diffY * diffY), .01)

		# find the difference, or the ratio of how far along the restingDistance the actual distance is.
		var difference = (resting_distance - d) / d

		# if the distance is more than curtainTearSensitivity, the cloth tears
		if d > tear_sensitivity:
			p1.remove_link(self)

		# Inverse the mass quantities
		var im1 = 1 / p1.mass
		var im2 = 1 / p2.mass
		var scalar_p1 = (im1 / (im1 + im2)) * stiffness
		var scalar_p2 = stiffness - scalar_p1

		# Push/pull based checked mass
		# heavier objects will be pushed/pulled less than attached light objects
		p1.pos.x += diffX * scalar_p1 * difference
		p1.pos.y += diffY * scalar_p1 * difference

		p2.pos.x -= diffX * scalar_p2 * difference
		p2.pos.y -= diffY * scalar_p2 * difference


func _on_Rose_turned():
	reassign_pins()


func _on_rose_turned():
	flip_targets()
