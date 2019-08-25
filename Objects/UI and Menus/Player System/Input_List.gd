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
		get_child(idx).connect('focus_entered', self, '_on_focus_change')

func connect_lowest_child(child):
	if(child.get_child_count() != 0):
		connect_lowest_child(child.get_child(child.get_child_count()-1));
	else:
		Button_List_Children.push_back(child);
		child.connect("disable_all",self,"on_disable_all");
		child.connect("enable_all",self,"on_enable_all");
		child.init();
		for childs_child in child.get_children():
			childs_child.connect('focus_entered', self, '_on_focus_change')

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
		for childs_child in child.get_children():
			childs_child.queue_free();
		child.set_reinit();
	UserSettings._create_default_key_bindings();

onready var scroll_container = get_parent()

func _on_focus_change():
	var focused = get_focus_owner()
	var focus_offset = focused.get_parent().get_parent().get_parent().rect_position.y

	var scrolled_top = scroll_container.get_v_scroll()
	var scrolled_bottom = scrolled_top + scroll_container.get_size().y - focused.get_size().y
	
	if focus_offset < scrolled_top or focus_offset >= scrolled_bottom:
		scroll_container.set_v_scroll(focus_offset)