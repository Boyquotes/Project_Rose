extends EditorInspectorPlugin


const GenParentButton := preload("generate_parent_hitbox_button.gd")
const GenChildButton := preload("generate_child_hitbox_button.gd")

func can_handle(object):
	return object is EnemyHitbox or object is EnemyHitboxContainer


func parse_begin(object : Object):
	var child_button = GenChildButton.new()
	add_custom_control(child_button)
	child_button.connect("button_down",Callable(object,"create_child"))
	if object is EnemyHitbox:
		var parent_button = GenParentButton.new()
		add_custom_control(parent_button)
		parent_button.connect("button_down",Callable(object,"create_parent"))
