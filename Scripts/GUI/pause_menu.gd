extends PanelContainer

@export var controls_menu_path : NodePath
var controls_menu

func _ready():
	controls_menu = get_node(controls_menu_path)
	hide();
	controls_menu.hide()

func hide_all():
	controls_menu.hide()
	hide()

func _on_MainMenuButton_pressed():
	pass
	#get_tree().paused = false;
	#get_tree().change_scene("res://Scenes/MainMenu/MainMenu.tscn")


func _on_close_menu_button_pressed():
	hide_all()
	get_parent().grab_focus();
	get_tree().paused = false;


func _on_controls_menu_button_pressed():
	controls_menu.show()
	controls_menu.def.grab_focus()
	get_parent().can_unpause = false


func _on_exit_game_button_pressed():
	get_tree().quit();

