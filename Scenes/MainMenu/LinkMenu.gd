extends VBoxContainer

func _on_TwitterButton_pressed():
	OS.shell_open("https://twitter.com/tyodevs");

func _on_PatreonButton_pressed():
	OS.shell_open("https://www.patreon.com/Tyo");

func _on_TwitchButton_pressed():
	OS.shell_open("https://www.twitch.tv/tyodevs");

func _on_YTButton_pressed():
	OS.shell_open("https://www.youtube.com/channel/UCLifYFuLPaQwH7YdtBh1uuA");
