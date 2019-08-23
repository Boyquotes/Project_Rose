extends VBoxContainer

signal disable_all;
signal enable_all;
var Button_List_Children = [];
export(NodePath) var hostpath;
var host

func _ready():
	host = get_node(hostpath);
	for idx in get_child_count():
		if(idx > 1):
			connect_lowest_child(get_child(idx));

func connect_lowest_child(child):
	if(child.get_child_count() != 0):
		connect_lowest_child(child.get_child(child.get_child_count()-1));
	else:
		Button_List_Children.push_back(child);
		child.connect("disable_all",self,"on_disable_all");
		child.connect("enable_all",self,"on_enable_all");
		child.init();

func on_enable_all():
	for child in Button_List_Children:
		for childs_child in child.get_children():
			childs_child.disabled = false;
	host.emit_signal("set_disabled",false);

func on_disable_all():
	for child in Button_List_Children:
		for childs_child in child.get_children():
			childs_child.disabled = true;
	host.emit_signal("set_disabled",true);

func _on_DefaultButton_pressed():
	InputMap.load_from_globals();
	for child in Button_List_Children:
		child.init();
	UserSettings._create_default_key_bindings();
