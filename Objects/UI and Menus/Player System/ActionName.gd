extends PanelContainer

export(String) var Action_Name;

func _ready():
	var timer = Timer.new();
	get_child(0).add_child(timer);
	get_child(0).move_child(timer, 0);
	timer.wait_time = 0.05;
	timer.one_shot = true;
	timer.name = "initTimer";
	timer.connect("timeout",$ActionHBox/InputButtonList,"on_timeout");