class_name ClothSim
extends Node2D

export(NodePath) var phys_obj_path
export(NodePath) var targets_path
export(NodePath) var influencers_path

var influencers_node
var phys_obj_node
var targets_node : Node2D
var physics : ClothPhysics
var pointmasses : Array
var targets : Array

# every PointMass within this many pixels will be influenced by the cursor
var mouse_influence_size := 10.0
# minimum distance for tearing when user is right clicking
var mouse_tear_size := 1.0
var mouse_influence_scalar := 10.0

var gravity := 480.0

var cloth_height := 8
var cloth_width := 4
var resting_distances := 4
var stiffnesses := .75
var tear_sensitivity := 500 # distance the PointMasss have to go before ripping

var mouse_position := Vector2()
var prev_mouse_position := Vector2()

func _ready():
	physics = ClothPhysics.new()
	physics.fixed_deltatime = 16
	physics.fixed_deltatime_seconds = float(physics.fixed_deltatime) / 1000.0
	physics.leftover_deltatime = 0
	physics.constraint_accuracy = 3
	
	mouse_influence_size *= mouse_influence_size 
	mouse_tear_size *= mouse_tear_size
	
	mouse_position = get_local_mouse_position()
	prev_mouse_position = Vector2(0, 0)
	
	phys_obj_node = get_node(phys_obj_path)
	
	influencers_node = get_node(influencers_path)
	
	targets_node = get_node(targets_path)
	
	create_cloth(targets_node.global_position, self)

func create_cloth(translation : Vector2, this : ClothSim):
	# mid_width: amount to translate the curtain along x-axis for it to be centered
	# (curtainWidth * restingDistances) = curtain's pixel width
	#var mid_width = int(width/2 - (curtainWidth * restingDistances)/2)
	
	# Since this our fabric is basically a grid of points, we have two loops
	for y in cloth_height: # due to the way PointMasss are attached, we need the y loop on the outside
		pointmasses.push_back([])
		for x in cloth_width:
			var pointmass = PointMass.new(translation.x + x * this.resting_distances, translation.y + y * this.resting_distances, x, y)
			# attach to 
			# x - 1  and
			# y - 1  
			#  *<---*<---*<-..
			#  ^    ^    ^
			#  |    |    |
			#  *<---*<---*<-..
			#
			# PointMass attach_to parameters: PointMass PointMass, float restingDistance, float stiffness
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
				print(target.position)
				this.targets.push_back(target)
				pointmass.pin_to(target)
			# add to PointMass array  
			pointmasses[y].push_back(pointmass)


func _draw():
	for pointmass_arr in pointmasses:
		for pointmass in pointmass_arr:
			for link in pointmass.links:
				draw_line(link.p1.pos, link.p2.pos, Color("a7292d"))
	for y in pointmasses.size():
		for x in pointmasses[y].size():
			var points
			var colors
			if y > 0 and x > 0 and y < pointmasses.size()-1 and x < pointmasses[y].size()-1:
				points = [pointmasses[y][x].pos, pointmasses[y-1][x].pos, pointmasses[y][x+1].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
				points = [pointmasses[y][x].pos, pointmasses[y-1][x].pos, pointmasses[y][x-1].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
				points = [pointmasses[y][x].pos, pointmasses[y+1][x].pos, pointmasses[y][x+1].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
				points = [pointmasses[y][x].pos, pointmasses[y+1][x].pos, pointmasses[y][x-1].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
			if x == 0 and y > 0 and y < pointmasses.size()-1:
				points = [pointmasses[y][x].pos, pointmasses[y-1][x].pos, pointmasses[y-1][x+1].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
				points = [pointmasses[y][x].pos, pointmasses[y+1][x].pos, pointmasses[y+1][x+1].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
			if x == pointmasses[y].size()-1 and y > 0 and y < pointmasses.size()-1:
				points = [pointmasses[y][x].pos, pointmasses[y-1][x].pos, pointmasses[y-1][x-1].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
				points = [pointmasses[y][x].pos, pointmasses[y+1][x].pos, pointmasses[y+1][x-1].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
			if y == 0 and x > 0 and x < pointmasses[y].size()-1:
				points = [pointmasses[y][x].pos, pointmasses[y][x-1].pos, pointmasses[y+1][x].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
				points = [pointmasses[y][x].pos, pointmasses[y][x+1].pos, pointmasses[y+1][x].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
			if y == pointmasses.size()-1 and x > 0 and x < pointmasses[y].size()-1:
				points = [pointmasses[y][x].pos, pointmasses[y][x-1].pos, pointmasses[y-1][x].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
				points = [pointmasses[y][x].pos, pointmasses[y][x+1].pos, pointmasses[y-1][x].pos]
				colors = [Color("a7292d"), Color("a7292d"), Color("a7292d")]
				draw_polygon(PoolVector2Array(points), PoolColorArray(colors))
			if y == pointmasses.size()-1 and x < pointmasses[y].size()-1:
				draw_line(pointmasses[y][x].pos, pointmasses[y][x+1].pos, Color("f8ffde"), 2)
	
var mouse_moved := false

func _physics_process(_delta):
	z_index = targets_node.z_index
	
	update()
	
	physics.update(self)
	


# Physics
# Timesteps are managed here
class ClothPhysics:
	var previous_time := 0.0
	var current_time := 0.0
	
	var fixed_deltatime := 0
	var fixed_deltatime_seconds := 0.0
	
	var leftover_deltatime := 0
	
	var constraint_accuracy := 0
	
	# Update physics
	func update(this : ClothSim):
		# calculate elapsed time
		current_time = OS.get_system_time_msecs()
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
			# solve the constraints multiple times
			# the more it's solved, the more accurate.
			for x in constraint_accuracy:
				for pointmass_arr in this.pointmasses:
					for pointmass in pointmass_arr:
						pointmass.solve_constraints(this)
			
			# update each PointMass's position
			for pointmass_arr in this.pointmasses:
				for pointmass in pointmass_arr:
					pointmass.update_interactions(this)
					pointmass.update_physics(fixed_deltatime_seconds, this)

class PointMass:
	# for calculating position change (velocity)
	var last_x := 0.0
	var last_y := 0.0
	var pos := Vector2()
	var acc_x := 0.0
	var acc_y := 0.0
	
	var xplace := 0
	var yplace := 0
	 
	var mass := 1.0
	var damping := 50.0
	
	# An Array for links, so we can have as many links as we want to this PointMass
	var links = []
	
	var pinned := false
	var pin : Position2D
	
	# PointMass constructor
	func _init(var x_pos : float, var y_pos : float, var x : int, y : int):
		pos.x = x_pos
		pos.y = y_pos
		
		last_x = pos.x
		last_y = pos.y
		
		xplace = x
		yplace = y

	# The update function is used to update the physics of the PointMass.
	# motion is applied, and links are drawn here
	# timeStep should be in elapsed seconds (deltaTime)
	func update_physics(var timestep : float, this : ClothSim):
		apply_force(mass * -this.phys_obj_node.vel.x, mass * this.gravity + mass * -this.phys_obj_node.vel.y)
		
		var vel_x = pos.x - last_x
		var vel_y = pos.y - last_y
		
		# dampen velocity
		vel_x *= 0.99
		vel_y *= 0.99
		
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
	
	func update_interactions(this : ClothSim):
		# this is where our interaction comes in.
		for influencer in this.influencers_node.get_children():
			if influencer.moved:
				var inf_pos = this.to_local(influencer.global_position)
				var inf_prev_pos = this.to_local(influencer.prev_glob_position)
				var distance_squared = dist_line_to_point_sq(inf_prev_pos, inf_pos, pos)
				if distance_squared < this.mouse_influence_size:
					# remember mouseInfluenceSize was squared in setup()
					# To change the velocity of our PointMass, we subtract that change from the lastPosition.
					# When the physics gets integrated (see updatePhysics()), the change is calculated
					# Here, the velocity is set equal to the cursor's velocity
					last_x = pos.x - (inf_pos.x - inf_prev_pos.x) * this.mouse_influence_scalar
					last_y = pos.y - (inf_pos.y - inf_prev_pos.y) * this.mouse_influence_scalar
				else:  
				# if the right mouse button is clicking, we tear the cloth by removing links
					if distance_squared < this.mouse_tear_size:
						links.clear()
	
	func _draw():
		# draw the links and points
		#stroke(0)
		if links:
			for link in links:
				link.draw()
		else:
			#point(x, y)
			pass
	
	""" Constraints """
	func solve_constraints(this : ClothSim):
		""" Link Constraints """
		# Links make sure PointMasss connected to this one is at a set distance away
		for link in links:
			link.solve()
	
		""" Other Constraints """
		# make sure the PointMass stays in its place if it's pinned
		if pinned:
			pos = this.to_local(pin.global_position)
		
		if xplace == 4:
			if pos.x > 16 and pos.y > 1:
				pos.x = 2 * (16 - 1) - pos.x;
		
	# attach_to can be used to create links between this PointMass and other PointMasss
	func attach_to(P : PointMass, this : ClothSim, drawLink : bool = true):
		var link = Link.new(self, P, this, drawLink)
		links.push_back(link)
	
	func remove_link(link : Link):
		links.erase(link)
	
	func pin_to(target : Position2D):
		pinned = true
		pin = target
	
	func apply_force(fx : float, fy : float):
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

class Link:
	var resting_distance := 0.0
	var stiffness := 0.0
	var tear_sensitivity := 0.0
	
	var p1 : PointMass
	var p2 : PointMass
	
	# if you want this link to be invisible, set this to false
	var draw_this := true
	
	func _init(which1 : PointMass, which2 : PointMass, this : ClothSim, drawMe : bool):
		p1 = which1 # when you set one object to another, it's pretty much a reference. 
		p2 = which2 # Anything that'll happen to p1 or p2 in here will happen to the paticles in our ArrayList
		
		resting_distance = this.resting_distances
		stiffness = this.stiffnesses
		draw_this = drawMe
		
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

		# Push/pull based on mass
		# heavier objects will be pushed/pulled less than attached light objects
		p1.pos.x += diffX * scalar_p1 * difference
		p1.pos.y += diffY * scalar_p1 * difference

		p2.pos.x -= diffX * scalar_p2 * difference
		p2.pos.y -= diffY * scalar_p2 * difference
	
	
	# Draw if it's visible
	func debug_draw():
		if draw_this:
			pass#line(p1.x, p1.y, p2.x, p2.y)
