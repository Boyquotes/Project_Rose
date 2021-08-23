class_name ClothSim
extends Node2D

var physics : ClothPhysics
var pointmasses : Array

# every PointMass within this many pixels will be influenced by the cursor
var mouse_influence_size := 2.0
# minimum distance for tearing when user is right clicking
var mouse_tear_size := 1.0
var mouse_influence_scalar := 1.0

var gravity := 980.0

var cloth_height := 5
var cloth_width := 5
var y_start = 25 # where will the curtain start on the y axis?
var resting_distances := 10
var stiffnesses := 1
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
	
	create_cloth(100.0, self)

func create_cloth(translation : float, this : ClothSim):
	# mid_width: amount to translate the curtain along x-axis for it to be centered
	# (curtainWidth * restingDistances) = curtain's pixel width
	#var mid_width = int(width/2 - (curtainWidth * restingDistances)/2)
	
	# Since this our fabric is basically a grid of points, we have two loops
	for y in cloth_height: # due to the way PointMasss are attached, we need the y loop on the outside
		for x in cloth_width:
			var pointmass = PointMass.new(translation + x * this.resting_distances, y * this.resting_distances + this.y_start)
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
				pointmass.attach_to(pointmasses[pointmasses.size()-1], this)
			# the index for the PointMasss are one dimensions, 
			# so we convert x,y coordinates to 1 dimension using the formula y*width+x  
			if y != 0:
				pointmass.attach_to(pointmasses[(y - 1) * (this.cloth_width+1) + x], this)
				
			# we pin the very top PointMasss to where they are
			if y == 0:
				pointmass.pin_to(pointmass.pos.x, pointmass.pos.y)
			# add to PointMass array  
			pointmasses.push_back(pointmass)

func _draw():
	for pointmass in pointmasses:
		for link in pointmass.links:
			draw_line(link.p1.pos, link.p2.pos, Color.red)

var mouse_moved := false

func _physics_process(_delta):
	if mouse_position != get_local_mouse_position():
		mouse_moved = true
		prev_mouse_position = mouse_position
		mouse_position = get_local_mouse_position()
	update()
	
	#physics.update(self)
	


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
				for pointmass in this.pointmasses:
					pointmass.solve_constraints()
			
			# update each PointMass's position
			for pointmass in this.pointmasses:
				pointmass.update_interactions(this)
				pointmass.update_physics(fixed_deltatime_seconds, this)

class PointMass:
	# for calculating position change (velocity)
	var last_x := 0.0
	var last_y := 0.0
	var pos := Vector2()
	var acc_x := 0.0
	var acc_y := 0.0
	
	var mass := 1.0
	var damping := 20.0
	
	# An Array for links, so we can have as many links as we want to this PointMass
	var links = []
	
	var pinned := false
	var pin_x
	var pin_y
	
	# PointMass constructor
	func _init(var x_pos : float, var y_pos):
		pos.x = x_pos
		pos.y = y_pos
		
		last_x = pos.x
		last_y = pos.y

	# The update function is used to update the physics of the PointMass.
	# motion is applied, and links are drawn here
	# timeStep should be in elapsed seconds (deltaTime)
	func update_physics(var timestep : float, this : ClothSim):
		apply_force(0, mass * this.gravity)
		
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
		if Input.is_action_pressed("click"):
			var distance_squared = dist_line_to_point_sq(this.prev_mouse_position, this.mouse_position, pos)
			if distance_squared < this.mouse_influence_size:
				# remember mouseInfluenceSize was squared in setup()
				# To change the velocity of our PointMass, we subtract that change from the lastPosition.
				# When the physics gets integrated (see updatePhysics()), the change is calculated
				# Here, the velocity is set equal to the cursor's velocity
				last_x = pos.x - (this.mouse_position.x - this.prev_mouse_position.x) * this.mouse_influence_scalar
				last_y = pos.y - (this.mouse_position.y - this.prev_mouse_position.y) * this.mouse_influence_scalar
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
	func solve_constraints():
		""" Link Constraints """
		# Links make sure PointMasss connected to this one is at a set distance away
		for link in links:
			link.solve()
	
		""" Other Constraints """
		# make sure the PointMass stays in its place if it's pinned
		if pinned:
			pos.x = pin_x
			pos.y = pin_y 

	# attach_to can be used to create links between this PointMass and other PointMasss
	func attach_to(P : PointMass, this : ClothSim, drawLink : bool = true):
		var link = Link.new(self, P, this, drawLink)
		links.push_back(link)
	
	func remove_link(link : Link):
		links.erase(link)
	
	func pin_to(px : float, py : float):
		pinned = true
		pin_x = px
		pin_y = py
	
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
		var d = sqrt(diffX * diffX + diffY * diffY)

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
