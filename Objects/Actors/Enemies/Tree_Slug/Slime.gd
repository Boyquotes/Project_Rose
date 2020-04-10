extends Line2D

signal call_point_timer;

export(NodePath) var targetPath;
var target;
var length = 100;
var switch = true;
var h = 0;
var prev_pos;
var right_most = Vector2(0,0);
var left_most = Vector2(0,0);
var decay = false;
onready var host = get_parent();

func _ready():
	prev_pos = global_position;
	
	target = get_node(targetPath);
	for i in 25:
		add_point(target.global_position);
	
	var scene = get_parent().get_parent();
	get_parent().call_deferred("remove_child",self);
	scene.call_deferred("add_child",self);

func _process(delta):
	global_position = Vector2(0,0);
	global_rotation = 0;
	
	while(get_point_position(get_point_count()-1).distance_to(target.global_position) > 0.5):
		var rad = get_point_position(get_point_count()-1).angle_to_point(target.global_position)
		var newx = cos(rad);
		var newy = sin(rad);
		add_point(get_point_position(get_point_count()-1) - Vector2(newx,newy));
	while(get_point_count() > 250):
		remove_point(0);
	if(decay):
		if(get_point_count() > 1):
			remove_point(0);
		else:
			queue_free();

func _on_changeHitboxTimer_timeout():
	right_most = target.global_position;
	left_most = target.global_position;
	
	for idx in get_point_count():
		if(get_point_position(idx).x < left_most.x):
			left_most = get_point_position(idx);
		if(get_point_position(idx).x > right_most.x):
			right_most = get_point_position(idx);
	
	$SlowPlayerHitbox.global_position = (Vector2((left_most.x+right_most.x)/2, (left_most.y+right_most.y)/2));
	$SlowPlayerHitbox/CollisionShape2D2.shape.extents.x = left_most.distance_to(right_most)/2;

func _on_Tree_Slug_tree_exiting():
	#var scene = get_parent().get_parent();
	#get_parent().remove_child(self);
	#scene
	target = Position2D.new();
	get_parent().get_parent().call_deferred("add_child",target);
	target.global_position = get_point_position(get_point_count()-1) + Vector2(65,0) * -host.Direction;
	decay = true;
