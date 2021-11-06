extends Node2D

export(NodePath) var host_path
var host

func init():
	host = get_node(host_path)
	host.call_init_in_children(host, self)
