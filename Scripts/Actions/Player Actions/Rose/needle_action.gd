class_name NeedleAction
extends CharAction

@onready var area : Area2D = $Hitboxes/Area2D
@onready var line : Line2D = $Sprites/Line2D
var hit := false
var hpos := Vector2()
var lpos := 0
func execute(_delta):
	resolve_needle(area.rotation)

func resolve_needle(rot):
	if not area.get_child(0).disabled and not hit:
		var space_state : PhysicsDirectSpaceState2D = get_world_2d().direct_space_state
		
		var ray1 : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
			(global_position + Vector2(0, 1)).rotated(rot),
			(global_position + Vector2(350*host.hor_dir, 1)).rotated(rot),
			area.collision_mask)
		var ray2 : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
			(global_position + Vector2(0, 0)).rotated(rot),
			(global_position + Vector2(350*host.hor_dir, 0)).rotated(rot),
			area.collision_mask)
		var ray3 : PhysicsRayQueryParameters2D = PhysicsRayQueryParameters2D.create(
			(global_position + Vector2(0, -1)).rotated(rot),
			(global_position + Vector2(350*host.hor_dir, -1)),
			area.collision_mask)
		
		ray1.hit_from_inside = true
		ray2.hit_from_inside = true
		ray3.hit_from_inside = true
		
		ray1.collide_with_bodies = false
		ray2.collide_with_bodies = false
		ray3.collide_with_bodies = false
		
		ray1.collide_with_areas = true
		ray2.collide_with_areas = true
		ray3.collide_with_areas = true
		var collision_events = [space_state.intersect_ray(ray1),
		space_state.intersect_ray(ray2),
		space_state.intersect_ray(ray3)]
		
		for event in collision_events:
			if event:
				hit = true
				hpos = event.position
				return
	if hit:
		line.set_point_position(1, to_local(hpos))
		
		if line.get_point_position(0).length() < line.get_point_position(1).length():
			lpos += 20
			line.set_point_position(0, Vector2(lpos,0).rotated(rot))
		if line.get_point_position(0).length() > line.get_point_position(1).length():
			line.set_point_position(0, line.get_point_position(1))
	elif area.get_child(0).disabled:
		line.set_point_position(1, Vector2(250, 0).rotated(rot))
		
		if line.get_point_position(0).length() < line.get_point_position(1).length():
			lpos += 20
			line.set_point_position(0, Vector2(lpos,0).rotated(rot))
		if line.get_point_position(0).length() > line.get_point_position(1).length():
			line.set_point_position(0, line.get_point_position(1))
