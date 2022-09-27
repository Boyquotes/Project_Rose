extends EditorProperty
class_name SS2D_NormalRangeEditorProperty

var control = preload("res://addons/rmsmartshape/editors/NormalRangeEditor/NormalRangeEditor.tscn").instantiate()

func _init():
	add_child(control)
	add_focusable(control)

func _enter_tree():
	control.connect("value_changed",Callable(self,"_value_changed"))
	_value_changed()

func _exit_tree():
	control.disconnect("value_changed",Callable(self,"_value_changed"))

func _value_changed():
	var obj = get_edited_object()
	control.end = obj.end - obj.begin
	control.start = obj.begin
