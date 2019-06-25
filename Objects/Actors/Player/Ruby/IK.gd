extends Node2D

export(NodePath) var ik_bonePath;
var ik_bone;
export(NodePath) var targetPath;
var target;
export var ik_limit = 2;
export(NodePath) var skeletonPath;
var skeleton;

func _ready():
	target = get_node(targetPath);
	skeleton = get_node(skeletonPath);
	ik_bone = get_node(ik_bonePath);
	set_process(true);
	print(ik_bone.global_position + Vector2(cos(rotation) * ik_bone.default_length, sin(rotation) * ik_bone.default_length));
	print(target.global_position);

func pass_chain(delta):
	
	if(ik_bone.global_position + Vector2(cos(rotation) * ik_bone.default_length, sin(rotation) * ik_bone.default_length) != target.global_position):
		var b = skeleton.get_bone(ik_bone.get_index_in_skeleton())
		var l = ik_limit;
		while b.get_index_in_skeleton() >= 0 and l > 0:
			b.rotation = atan((target.global_position.y - b.global_position.y) / (target.global_position.x - b.global_position.x));
			b = skeleton.get_bone(b.get_index_in_skeleton()-1);
			l = l - 1

func _process(delta):
	pass_chain(delta);